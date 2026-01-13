const db = require("../../config/db");
const axios = require("axios");

exports.create = async (req, res) => {
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

    // ✅ Build Meta components
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

    // ✅ FINAL META PAYLOAD
    const metaPayload = {
      name: template_name,
      language,
      category,
      components,
    };

   
    const response = await axios.post(
      `https://graph.facebook.com/${process.env.VERSION}/${process.env.WABA_ID}/message_templates`,
      metaPayload,
      {
        headers: {
          Authorization: `Bearer ${process.env.META_ACCESS_TOKEN}`,
          "Content-Type": "application/json",
        },
      }
    );

    return res.json({
      success: true,
      data: response.data,
    });
  } catch (error) {
    console.error("Meta API error:", error.response?.data || error.message);

    return res.status(500).json({
      success: false,
      error: error.response?.data || error.message,
    });
  }
};
