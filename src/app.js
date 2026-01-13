const express = require("express");
const session = require("express-session");
const cors = require("cors");
require("dotenv").config();

const app = express();

app.use(
  cors({
    origin: true,
    credentials: true,
  })
);

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(
  session({
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: false,
  })
);

app.use(express.static("public"));
app.use("/api/auth", require("./routes/auth.routes"));
app.use("/api/contacts", require("./routes/contact.routes"));
app.use("/api/phonebook", require("./routes/phonebook.routes"));
app.use("/api/template", require("./routes/templates.routes"));
module.exports = app;
