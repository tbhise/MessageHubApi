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

  // 1️⃣ Get template details
  const [[template]] = await db.query(
    `
    SELECT name, language
    FROM templates
    WHERE id = ?
    `,
    [numericTemplateId],
  );

  if (!template) {
    throw new Error("Template not found");
  }

  const { name, language } = template;

  // 2️⃣ Payload
  const payload = {
    messaging_product: "whatsapp",
    to: mobile,
    type: "template",
    template: {
      name: name,
      language: {
        code: language || "en_US",
      },
    },
  };

  const url = `https://graph.facebook.com/${GRAPH_VERSION}/${messageFromMobNoId}/messages`;

  // 3️⃣ Send
  const response = await axios.post(url, payload, {
    headers: {
      Authorization: `Bearer ${ACCESS_TOKEN}`,
      "Content-Type": "application/json",
    },
  });

  return {
    success: true,
    message_id: response.data.messages?.[0]?.id,
  };
}
