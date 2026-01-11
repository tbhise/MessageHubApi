const router = require("express").Router();
const authMiddleware = require("../middlewares/auth.middleware");
const controller = require("../controllers/auth.controller");

router.post("/login", controller.login);

router.get("/profile", authMiddleware, (req, res) => {
  res.json({
    message: "Access granted",
    user: req.user,
  });
});

module.exports = router;
