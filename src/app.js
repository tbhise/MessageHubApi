const express = require("express");
const cors = require("cors");

const app = express();

// Middlewares
app.use(cors());
app.use(express.json());

// Routes
app.use("/api", require("./routes"));

// Default route
app.get("/", (req, res) => {
  res.json({ status: "API running 🚀" });
});

module.exports = app;
