const db = require("../../config/db");


exports.list = async (req, res) => {
  try {
    const [rows] = await db.execute("SELECT * FROM contacts order by id desc");

    res.json({
      success: true,
      data: rows,
    });
  } catch (err) {
    console.error("DATA LIST ERROR:", err);
    res.status(500).json({ message: "Server error" });
  }
};

exports.create = async (req, res) => {
  try {
    const { phone_number, full_name, source = "manual" } = req.body;

    // 🔐 basic validation
    if (!phone_number) {
      return res.status(400).json({
        success: false,
        message: "Phone number is required",
      });
    }

    // optional: get logged-in user id (JWT middleware)
    const userId = req.user?.id || null;

    // check duplicate (important)
    const [existing] = await db.query(
      "SELECT id FROM contacts WHERE phone_number = ? AND isDeleted = 0",
      [phone_number]
    );

    if (existing.length > 0) {
      return res.status(409).json({
        success: false,
        message: "Contact already exists",
      });
    }

    // insert contact
    const [result] = await db.query(
      `
      INSERT INTO contacts
      (
        phone_number,
        full_name,
        source,
        isDeleted,
        created_at,
        created_by,
        updated_at,
        updated_by
      )
      VALUES (?, ?, ?, 0, NOW(), ?, NOW(), ?)
      `,
      [phone_number, full_name || null, source, userId, userId]
    );

    return res.status(201).json({
      success: true,
      message: "Contact created successfully",
      data: {
        id: result.insertId,
        phone_number,
        full_name,
        source,
      },
    });
  } catch (err) {
    console.error("CREATE CONTACT ERROR:", err);
    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
};

