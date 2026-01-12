const router = require("express").Router();
const authMiddleware = require("../middlewares/auth.middleware");
const controller = require("../controllers/contacts/phonebook.controller");
const upload = require("../middlewares/upload");

router.post("/list", authMiddleware, controller.list);

router.post(
  "/import",
  upload.single("file"),
  authMiddleware,
  controller.createPhonebookAndImportContacts
);

module.exports = router;
