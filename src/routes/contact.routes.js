const router = require("express").Router();
const authMiddleware = require("../middlewares/auth.middleware");
const controller = require("../controllers/contacts/contact.controller");

router.post("/list", authMiddleware, controller.list);
router.post("/create", authMiddleware, controller.create);

module.exports = router;
