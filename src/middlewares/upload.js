const multer = require("multer");
const path = require("path");

const storage = multer.diskStorage({
  destination: "uploads/",
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

const allowedExtensions = [".xls", ".xlsx", ".csv"];

const upload = multer({
  storage,
  fileFilter: (req, file, cb) => {
    const ext = path.extname(file.originalname).toLowerCase();

    if (allowedExtensions.includes(ext)) {
      cb(null, true);
    } else {
      cb(new Error("Only .xls, .xlsx and .csv files are allowed"));
    }
  },
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB
  },
});

module.exports = upload;
