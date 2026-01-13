const multer = require("multer");
const path = require("path");

/* =========================
   COMMON STORAGE
========================= */

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/");
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

/* =========================
   1️⃣ PHONEBOOK IMPORT
========================= */

const phonebookExtensions = [".xls", ".xlsx", ".csv"];

const uploadPhonebook = multer({
  storage,
  fileFilter: (req, file, cb) => {
    const ext = path.extname(file.originalname).toLowerCase();

    if (phonebookExtensions.includes(ext)) {
      cb(null, true);
    } else {
      cb(new Error("Only .xls, .xlsx and .csv files are allowed"));
    }
  },
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB
  },
});

/* =========================
   2️⃣ TEMPLATE HEADER MEDIA
========================= */

const templateExtensions = {
  image: [".jpg", ".jpeg", ".png"],
  video: [".mp4"],
  document: [".pdf"],
};

const uploadTemplateHeader = multer({
  storage,
  fileFilter: (req, file, cb) => {
    const ext = path.extname(file.originalname).toLowerCase();
    const headerType = req.body.header_type; // image | video | document

    if (!headerType || !templateExtensions[headerType]) {
      return cb(new Error("Invalid or missing header_type"));
    }

    if (templateExtensions[headerType].includes(ext)) {
      cb(null, true);
    } else {
      cb(
        new Error(
          `Invalid file type for ${headerType}. Allowed: ${templateExtensions[
            headerType
          ].join(", ")}`
        )
      );
    }
  },
  limits: {
    fileSize: 100 * 1024 * 1024, // 100MB (Meta allows large docs)
  },
});

module.exports = {
  uploadPhonebook,
  uploadTemplateHeader,
};
