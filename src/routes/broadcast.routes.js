const router = require("express").Router();
const authMiddleware = require("../middlewares/auth.middleware");
const controller = require("../controllers/broadcast/broadcast.controller");
const multer = require("multer");
const upload = multer();

router.post("/mobileno/list", authMiddleware, controller.list);
router.post(
  "/send-message",
  authMiddleware,
  upload.none(),
  controller.sendMessage,
);

module.exports = router;
