const express = require("express");
const route = express.Router();
const Transaction = require("./../model/transaction");
const { Webhook, createPayment } = require("../controller/webhook_controller");
require("dotenv").config();

route.post("/webhook", Webhook);

// test purpose
route.post("/create-payment", createPayment);

module.exports = route;
