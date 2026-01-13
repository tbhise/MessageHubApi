const router = require("express").Router();
const authMiddleware = require("../middlewares/auth.middleware");
const { uploadTemplateHeader } = require("../middlewares/upload");
const controller = require("../controllers/templates/template.controller");

router.post(
  "/create",
  uploadTemplateHeader.single("file"),
  authMiddleware,
  controller.create
);

router.post("/sync-from-meta", controller.syncFromMeta);

module.exports = router;
