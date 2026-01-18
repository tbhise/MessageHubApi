const db = require("../../config/db");
const axios = require("axios");

exports.create = async (req, res) => {
  const conn = await db.getConnection();
  try {
    const {
      category,
      template_name,
      language,
      header_type,
      header_text,
      body_text,
      footer_text,
      buttons,
    } = req.body;
    // ✅ Parse buttons JSON
    const parsedButtons = buttons ? JSON.parse(buttons) : [];
    await conn.beginTransaction();
    // ===============================
    // 1️⃣ INSERT TEMPLATE (DRAFT)
    // ===============================
    const [templateResult] = await conn.execute(
      `
      INSERT INTO templates
      (
        name,
        language,
        category,
        previous_category,
        status,
        header_type,
        header_text,
        body_text,
        footer_text,
        created_by
      )
      VALUES (?, ?, ?, ?, 'DRAFT', ?, ?, ?, ?, ?)
      `,
      [
        template_name,
        language,
        category,
        category,
        header_type,
        header_text || null,
        body_text,
        footer_text || null,
        req.user?.id || 1,
      ],
    );
    const templateId = templateResult.insertId;
    // ===============================
    // 2️⃣ INSERT BUTTONS
    // ===============================
    for (let i = 0; i < parsedButtons.length; i++) {
      const btn = parsedButtons[i];
      await conn.execute(
        `
        INSERT INTO template_buttons
        (
          template_id,
          type,
          text,
          phone_number,
          url,
          ui_type,
          copy_value,
          position
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `,
        [
          templateId,
          btn.type,
          btn.text,
          btn.phone_number || null,
          btn.url || null,
          btn._uiType || null,
          btn.copy_value || null,
          i,
        ],
      );
    }
    // ===============================
    // 3️⃣ BUILD META COMPONENTS
    // ===============================
    const components = [];
    // HEADER
    if (header_type === "text" && header_text) {
      components.push({
        type: "HEADER",
        format: "TEXT",
        text: header_text,
      });
    }
    if (["image", "video", "document"].includes(header_type)) {
      components.push({
        type: "HEADER",
        format: header_type.toUpperCase(),
      });
    }
    // BODY (required)
    components.push({
      type: "BODY",
      text: body_text,
    });
    // FOOTER
    if (footer_text) {
      components.push({
        type: "FOOTER",
        text: footer_text,
      });
    }
    // BUTTONS
    if (parsedButtons.length > 0) {
      components.push({
        type: "BUTTONS",
        buttons: parsedButtons,
      });
    }
    // ===============================
    // 4️⃣ META PAYLOAD
    // ===============================
    const metaPayload = {
      name: template_name,
      language,
      category,
      parameter_format: "POSITIONAL",
      components,
    };
    // ===============================
    // 5️⃣ CALL META GRAPH API
    // ===============================
    const response = await axios.post(
      `https://graph.facebook.com/${process.env.VERSION}/${process.env.WABA_ID}/message_templates`,
      metaPayload,
      {
        headers: {
          Authorization: `Bearer ${process.env.META_ACCESS_TOKEN}`,
          "Content-Type": "application/json",
        },
      },
    );
    const metaData = response.data;
    // ===============================
    // 6️⃣ UPDATE TEMPLATE WITH META DATA
    // ===============================
    await conn.execute(
      `
      UPDATE templates
      SET
        meta_template_id = ?,
        status = ?
      WHERE id = ?
      `,
      [metaData.id, metaData.status || "PENDING", templateId],
    );
    // ===============================
    // 7️⃣ SAVE META LOG
    // ===============================
    await conn.execute(
      `
      INSERT INTO template_meta_logs
      (
        template_id,
        meta_status,
        meta_response
      )
      VALUES (?, ?, ?)
      `,
      [templateId, metaData.status || "PENDING", JSON.stringify(metaData)],
    );
    await conn.commit();
    return res.json({
      success: true,
      template_id: templateId,
      meta: metaData,
    });
  } catch (error) {
    await conn.rollback();
    console.error("Meta API error:", error.response?.data || error.message);

    return res.status(500).json({
      success: false,
      error: error.response?.data.error.error_user_msg || error.message,
    });
  } finally {
    conn.release();
  }
};

exports.syncFromMeta = async (req, res) => {
  const conn = await db.getConnection();

  try {
    await conn.beginTransaction();

    // 1️⃣ Fetch templates from Meta
    const metaRes = await axios.get(
      `https://graph.facebook.com/${process.env.VERSION}/${process.env.WABA_ID}/message_templates`,
      {
        headers: {
          Authorization: `Bearer ${process.env.META_ACCESS_TOKEN}`,
        },
      },
    );

    const metaTemplates = metaRes.data.data || [];

    for (const tpl of metaTemplates) {
      const {
        id: metaId,
        name,
        language,
        category,
        previous_category,
        status,
        components,
        parameter_format,
      } = tpl;

      // 2️⃣ Check if template exists
      const [existing] = await conn.execute(
        `SELECT id FROM templates WHERE meta_template_id = ?`,
        [metaId],
      );

      let templateId;

      if (existing.length === 0) {
        // ===============================
        // 3️⃣ INSERT TEMPLATE
        // ===============================
        const header = components.find((c) => c.type === "HEADER");
        const body = components.find((c) => c.type === "BODY");
        const footer = components.find((c) => c.type === "FOOTER");

        const [insertRes] = await conn.execute(
          `
          INSERT INTO templates
          (
            meta_template_id,
            name,
            language,
            category,
            previous_category,
            status,
            header_type,
            header_text,
            body_text,
            footer_text,
            parameter_format,
            created_by
          )
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
          `,
          [
            metaId,
            name,
            language,
            category,
            previous_category || null,
            status,
            header?.format ? header.format.toLowerCase() : "none",
            header?.text || null,
            body?.text || "",
            footer?.text || null,
            parameter_format || "POSITIONAL",
            req.user?.id || 1,
          ],
        );

        templateId = insertRes.insertId;
      } else {
        // ===============================
        // 4️⃣ UPDATE TEMPLATE
        // ===============================
        templateId = existing[0].id;

        await conn.execute(
          `
          UPDATE templates
          SET
            status = ?,
            category = ?,
            previous_category = ?,
            updated_at = CURRENT_TIMESTAMP
          WHERE id = ?
          `,
          [status, category, previous_category || null, templateId],
        );

        // Remove old buttons before re-inserting
        await conn.execute(
          `DELETE FROM template_buttons WHERE template_id = ?`,
          [templateId],
        );
      }

      // ===============================
      // 5️⃣ INSERT BUTTONS
      // ===============================
      const btnComponent = components.find((c) => c.type === "BUTTONS");

      if (btnComponent?.buttons?.length) {
        for (let i = 0; i < btnComponent.buttons.length; i++) {
          const btn = btnComponent.buttons[i];

          await conn.execute(
            `
            INSERT INTO template_buttons
            (
              template_id,
              type,
              text,
              phone_number,
              url,
              position
            )
            VALUES (?, ?, ?, ?, ?, ?)
            `,
            [
              templateId,
              btn.type,
              btn.text,
              btn.phone_number || null,
              btn.url || null,
              i,
            ],
          );
        }
      }

      // ===============================
      // 6️⃣ SAVE META LOG
      // ===============================
      await conn.execute(
        `
        INSERT INTO template_meta_logs
        (
          template_id,
          meta_status,
          meta_response
        )
        VALUES (?, ?, ?)
        `,
        [templateId, status, JSON.stringify(tpl)],
      );
    }

    await conn.commit();

    res.json({
      success: true,
      synced: metaTemplates.length,
    });
  } catch (err) {
    await conn.rollback();
    console.error("Sync error:", err.response?.data || err.message);

    res.status(500).json({
      success: false,
      error: err.response?.data || err.message,
    });
  } finally {
    conn.release();
  }
};

exports.list = async (req, res) => {
  try {
    const [rows] = await db.execute(`
      SELECT
        t.id,
        t.meta_template_id,
        t.name,
        t.language,
        t.category,
        t.previous_category,
        t.status,
        t.created_at,
        COUNT(b.id) AS button_count
      FROM templates t
      LEFT JOIN template_buttons b
        ON b.template_id = t.id
      GROUP BY t.id
      ORDER BY t.created_at DESC
    `);

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

exports.getTemplateById = async (req, res) => {
  const { id } = req.params;

  try {
    const [[template]] = await db.execute(
      `SELECT * FROM templates WHERE id = ?`,
      [id],
    );

    if (!template) {
      return res.status(404).json({
        success: false,
        message: "Template not found",
      });
    }

    const [buttons] = await db.execute(
      `
      SELECT
        type,
        text,
        phone_number,
        url,
        ui_type,
        copy_value,
        position
      FROM template_buttons
      WHERE template_id = ?
      ORDER BY position ASC
      `,
      [id],
    );

    return res.json({
      success: true,
      template,
      buttons,
    });
  } catch (error) {
    console.error("Fetch template error:", error);

    return res.status(500).json({
      success: false,
      error: error.message,
    });
  }
};

exports.syncno = async (req, res) => {
  try {
    const { metaPhoneNumberId } = req.body;
    const userId = req.user.id;
    const result = await syncAndLinkPhoneNumber(metaPhoneNumberId, userId);

    res.json(result);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

async function syncAndLinkPhoneNumber(metaPhoneNumberId, userId) {
  if (!metaPhoneNumberId) {
    throw new Error("metaPhoneNumberId is required");
  }
  if (!userId) {
    throw new Error("userId is required");
  }

  const GRAPH_VERSION = process.env.VERSION || "v22.0";
  const ACCESS_TOKEN = process.env.META_ACCESS_TOKEN;
  const WABA_ID = process.env.WABA_ID;

  if (!ACCESS_TOKEN || !WABA_ID) {
    throw new Error("Meta credentials missing");
  }

  // 1️⃣ Fetch from Meta
  let metaResponse;
  try {
    metaResponse = await axios.get(
      `https://graph.facebook.com/${GRAPH_VERSION}/${metaPhoneNumberId}`,
      {
        params: { fields: "display_phone_number,verified_name" },
        headers: { Authorization: `Bearer ${ACCESS_TOKEN}` },
      },
    );
  } catch (err) {
    console.error("Meta API error:", err.response?.data || err.message);
    throw new Error("Failed to fetch phone number from Meta");
  }

  const { display_phone_number, verified_name } = metaResponse.data;

  if (!display_phone_number) {
    throw new Error("display_phone_number missing from Meta response");
  }

  const conn = await db.getConnection();

  try {
    await conn.beginTransaction();

    // 2️⃣ Insert / Update phone number
    await conn.query(
      `
      INSERT INTO whatsapp_phone_numbers
        (meta_phone_number_id, display_phone_number, verified_name, waba_id, is_test_number)
      VALUES (?, ?, ?, ?, 1)
      ON DUPLICATE KEY UPDATE
        display_phone_number = VALUES(display_phone_number),
        verified_name = VALUES(verified_name),
        updated_at = CURRENT_TIMESTAMP
      `,
      [metaPhoneNumberId, display_phone_number, verified_name || null, WABA_ID],
    );

    // 3️⃣ Get INTERNAL whatsapp_phone_numbers.id
    const [[phoneRow]] = await conn.query(
      `
      SELECT id
      FROM whatsapp_phone_numbers
      WHERE meta_phone_number_id = ?
      `,
      [metaPhoneNumberId],
    );

    if (!phoneRow) {
      throw new Error("Failed to resolve internal phone ID");
    }

    const whatsappPhoneId = phoneRow.id;

    // 4️⃣ Link to logged-in user
    await conn.query(
      `
      INSERT IGNORE INTO user_whatsapp_numbers
        (user_id, whatsapp_phone_id, role)
      VALUES (?, ?, 'owner')
      `,
      [userId, whatsappPhoneId],
    );

    await conn.commit();

    return {
      meta_phone_number_id: metaPhoneNumberId,
      display_phone_number,
      verified_name,
      linked_to_user: userId,
      message: "Phone number synced and linked successfully",
    };
  } catch (err) {
    await conn.rollback();
    console.error("DB error:", err);
    throw new Error("Failed to sync & link phone number");
  } finally {
    conn.release();
  }
}
