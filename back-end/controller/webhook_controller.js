const Transaction = require("./../model/transaction");
const crypto = require("crypto");
require("dotenv").config();

exports.Webhook = async (req, res) => {
  try {
    // console.log("🔔 Webhook received:", req.body);
    const webhookSecret = process.env.CHAPA_WEBHOOK_SECRET;
    const signature =
      req.headers["x-chapa-signature"] || req.headers["Chapa-Signature"];

    const payload = JSON.stringify(req.body);
    const expectedSignature = crypto
      .createHmac("sha256", webhookSecret)
      .update(payload)
      .digest("hex");

    if (expectedSignature === signature) {
      console.log("Invalid signature " + expectedSignature + " & " + signature);
      return res.status(404).send({ error: "Invalid signature" });
    }

    const responseData = req.body;

    const {
      event,
      tx_ref,
      payment_method,
      reference,
      created_at,
      status,
      amount,
      customization,
    } = responseData || {};

    const checkReference = Transaction.findOne({
      reference
    });
    if(checkReference) {
      console.log("⚠️ Duplicate reference id: " + reference);
      return res.status(404).send({ error: "⚠️ Duplicate reference" });
    }

    if (event == "charge.success" && status == "success") {
      console.log("Payment was Successful");

      const existingTransaction = await Transaction.findOne({ tx_ref });
      if (existingTransaction) {
        return res.status(400).json({ error: "Transaction already processed" });
      }

      const botName =
        customization && customization.description
          ? customization.description
          : "Telegram";

      const newTransaction = new Transaction({
        botName,
        amount,
        tx_ref,
        payment_method,
        reference,
        created_at,
        timeStamp: new Date(),
      });
      await newTransaction.save();

      console.log(`✅ Payment successful for TX_REF: ${tx_ref}`);
      res.status(200).json({ message: "Transaction saved successfully" });
      return;
    }

    console.log("❌ Payment was unsuccessful");
    return res.status(400).json({ message: "Payment was unsuccessful" });
  } catch (e) {
    console.log("Webhook error " + e);
    res.status(404).send({ message: "Webhook error" });
  }
};

exports.createPayment = async (req, res) => {
  try {
    const paymentData = {
      tx_ref: `TX12345-${Date.now()}`,
      amount: 50.0,
      currency: "ETB",
      email: "abebech_bekele@gmail.com",
      first_name: "Yoni",
      phone_number: "0964582841",
      description: "Stake",
    };

    const response = await fetch(
      "https://api.chapa.co/v1/transaction/initialize",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${process.env.CHAPA_SECRET_KEY}`,
        },
        body: JSON.stringify(paymentData),
      }
    );

    const paymentResponse = await response.json();

    if (paymentResponse.status === "success") {
      res.json({ checkout_url: paymentResponse.data.checkout_url });
    } else {
      res
        .status(500)
        .json({ error: "Payment link creation failed", paymentResponse });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Internal server error" });
  }
};
