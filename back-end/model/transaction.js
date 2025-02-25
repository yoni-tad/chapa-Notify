const mongoose = require("mongoose");

const TransactionSchema = new mongoose.Schema({
  botName: { type: String, require: true },
  amount: { type: Number, require: true },
  tx_ref: { type: String, require: true },
  timeStamp: { type: String, require: true },
});

module.exports = mongoose.model("Transaction", TransactionSchema);
