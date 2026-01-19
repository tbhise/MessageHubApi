const db = require("../../config/db");
const axios = require("axios");

exports.list = async (req, res) => {
  try {
    const userId = req.user.id;
    const [rows] = await db.query(
      `SELECT
      wpn.id AS whatsapp_phone_id,
      wpn.meta_phone_number_id,
      wpn.display_phone_number,
      wpn.verified_name,
      wpn.is_test_number,
      wpn.status
    FROM user_whatsapp_numbers uwn
    JOIN whatsapp_phone_numbers wpn
      ON wpn.id = uwn.whatsapp_phone_id
    WHERE uwn.user_id = ?
      AND wpn.status = 'active'
    ORDER BY wpn.created_at DESC
    `,
      [userId],
    );

    return res.json({
      success: true,
      data: rows,
    });
  } catch (error) {
    console.error("Fetch templates error:", error);

    return res.status(500).json({
      success: false,
      error: error.message,
    });
  }
};

exports.sendMessage = async (req, res) => {
  try {
    const userId = req.user.id;
    console.log("FormData body:", req.body); // now works
    const { messageFromMobNoId, templateId, mobile } = req.body;

    const result = await sendWhatsappTemplateMessage({
      messageFromMobNoId,
      templateId: Number(templateId), // 👈 FormData = strings
      mobile,
    });

    return res.json(result);
  } catch (error) {
    console.error("Send message error:", error);

    return res.status(500).json({
      success: false,
      error: error.message,
    });
  }
};

async function sendWhatsappTemplateMessage({
  messageFromMobNoId,
  templateId,
  mobile,
  variables = {},
  header = null,
}) {
  const numericTemplateId = Number(templateId);

  if (!messageFromMobNoId || !mobile || Number.isNaN(numericTemplateId)) {
    throw new Error("Required fields missing");
  }

  const GRAPH_VERSION = process.env.VERSION || "v22.0";
  const ACCESS_TOKEN = process.env.META_ACCESS_TOKEN;

  if (!ACCESS_TOKEN) {
    throw new Error("Meta access token missing");
  }

  // 1️⃣ Fetch template
  const [[template]] = await db.query(
    `SELECT name, language, components FROM templates WHERE id = ?`,
    [numericTemplateId],
  );

  if (!template) throw new Error("Template not found");

  let templateComponents = template.components;

  // If string → parse
  if (typeof templateComponents === "string") {
    templateComponents = JSON.parse(templateComponents);
  }

  // If single object → wrap into array
  if (!Array.isArray(templateComponents)) {
    templateComponents = [templateComponents];
  }

  // 2️⃣ Build components dynamically
  const components = buildTemplateComponents(templateComponents, {
    variables,
    header,
  });

  // 3️⃣ Final payload
  const payload = {
    messaging_product: "whatsapp",
    to: mobile,
    type: "template",
    template: {
      name: template.name,
      language: { code: template.language || "en_US" },
      components,
    },
  };

  const url = `https://graph.facebook.com/${GRAPH_VERSION}/${messageFromMobNoId}/messages`;

  const response = await axios.post(url, payload, {
    headers: {
      Authorization: `Bearer ${ACCESS_TOKEN}`,
      "Content-Type": "application/json",
    },
  });

  const messageId = response.data.messages?.[0]?.id;

  // Save to DB
  await db.query(
    `INSERT INTO message_logs 
   (message_id, mobile, template_id, status)
   VALUES (?, ?, ?, ?)`,
    [messageId, mobile, numericTemplateId, "sent"],
  );

  return {
    success: true,
    message_id: response.data.messages?.[0]?.id,
  };
}

function buildTemplateComponents(templateComponents, input) {
  if (!Array.isArray(templateComponents)) {
    throw new Error("Template components must be an array");
  }

  const components = [];

  for (const comp of templateComponents) {
    if (!comp?.type) continue;

    // BODY
    if (comp.type === "body") {
      components.push({
        type: "body",
        parameters: (input.variables?.body || []).map((v) => ({
          type: "text",
          text: String(v),
        })),
      });
    }

    // HEADER
    if (comp.type === "header") {
      if (comp.format === "text") {
        components.push({
          type: "header",
          parameters: [
            {
              type: "text",
              text: input.header?.text || "",
            },
          ],
        });
      }

      if (["image", "video", "document"].includes(comp.format)) {
        components.push({
          type: "header",
          parameters: [
            {
              type: comp.format,
              [comp.format]: {
                link: input.header?.link,
              },
            },
          ],
        });
      }
    }

    // BUTTON
    if (comp.type === "button") {
      const btnVars = input.variables?.buttons?.[comp.index] || [];

      components.push({
        type: "button",
        sub_type: comp.sub_type,
        index: comp.index,
        parameters: btnVars.map((v) => ({
          type: "text",
          text: String(v),
        })),
      });
    }
  }

  return components;
}
