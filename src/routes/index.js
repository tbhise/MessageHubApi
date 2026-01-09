const express = require("express");
const router = express.Router();

router.get("/health", (req, res) => {
  res.json({
    success: true,
    message: "API is healthy",
  });
});

module.exports = router;
