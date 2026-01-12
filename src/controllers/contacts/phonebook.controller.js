const db = require("../../config/db");
const XLSX = require("xlsx");
const fs = require("fs");
const path = require("path");

exports.list = async (req, res) => {
  try {
    const [rows] = await db.execute(
      "SELECT * FROM phonebooks order by id desc"
    );

    res.json({
      success: true,
      data: rows,
    });
  } catch (err) {
    console.error("Phonebook LIST ERROR:", err);
    res.status(500).json({ message: "Server error" });
  }
};

exports.createPhonebookAndImportContacts = async (req, res) => {
  const connection = await db.getConnection();

  try {
    const { phonebook_name, description } = req.body;

    if (!phonebook_name) {
      return res.status(400).json({
        success: false,
        message: "phonebook_name is required",
      });
    }

    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: "File is required",
      });
    }

    const [records] = await db.execute(
      "SELECT * FROM phonebooks where name = ? ",
      [phonebook_name.trim()]
    );

    if (records.length > 0) {
      return res.status(400).json({
        success: false,
        message: "Phonebook name already exists.",
      });
    }

    const userId = req.user?.id || null;

    await connection.beginTransaction();

    const [phonebookResult] = await connection.query(
      `
      INSERT INTO phonebooks
      (
        name,
        description,
        total_contacts,
        created_at,
        created_by,
        updated_at,
        updated_by,
        is_deleted
      )
      VALUES (?, ?, 0, NOW(), ?, NOW(), ?, 0)
      `,
      [phonebook_name.trim(), description || null, userId, userId]
    );

    const phonebookId = phonebookResult.insertId;

    const workbook = XLSX.readFile(req.file.path);
    const sheet = workbook.Sheets[workbook.SheetNames[0]];

    const rows = XLSX.utils.sheet_to_json(sheet, {
      defval: "",
      raw: true, // IMPORTANT: avoid scientific notation
    });

    if (!rows.length) {
      throw new Error("Uploaded file is empty");
    }

    const values = [];
    const seen = new Set();

    const normalizePhone = (value) => {
      if (!value) return null;

      if (typeof value === "number") {
        return value.toFixed(0);
      }

      return value.toString().trim();
    };

    for (const row of rows) {
      const fullName = row.name?.toString().trim() || null;
      const phone = normalizePhone(row.phone_number);

      if (!phone) continue;

      const key = `${phonebookId}_${phone}`;
      if (seen.has(key)) continue;
      seen.add(key);

      values.push([
        phonebookId,
        phone,
        fullName,
        "phonebook",
        0,
        null, // deleted_at
        new Date(), // created_at
        userId,
        new Date(), // updated_at
        userId,
      ]);
    }

    if (!values.length) {
      throw new Error("No valid contacts found in file");
    }

    await connection.query(
      `
      INSERT INTO contacts
      (
        phonebook_id,
        phone_number,
        full_name,
        source,
        isDeleted,
        deleted_at,
        created_at,
        created_by,
        updated_at,
        updated_by
      )
      VALUES ?
      ON DUPLICATE KEY UPDATE
        full_name = VALUES(full_name),
        updated_at = VALUES(updated_at),
        updated_by = VALUES(updated_by)
      `,
      [values]
    );

    await connection.query(
      `
      UPDATE phonebooks
      SET total_contacts = (
        SELECT COUNT(*)
        FROM contacts
        WHERE phonebook_id = ?
          AND isDeleted = 0
      )
      WHERE id = ?
      `,
      [phonebookId, phonebookId]
    );

    await connection.commit();

    fs.unlinkSync(req.file.path);

    return res.status(201).json({
      success: true,
      message: "Phonebook created and contacts imported successfully",
      data: {
        phonebook_id: phonebookId,
        phonebook_name,
      },
    });
  } catch (err) {
    await connection.rollback();

    console.error("PHONEBOOK IMPORT ERROR:", err);

    if (req.file?.path && fs.existsSync(req.file.path)) {
      fs.unlinkSync(req.file.path);
    }

    return res.status(500).json({
      success: false,
      message: err.message || "Server error",
    });
  } finally {
    connection.release();
  }
};
