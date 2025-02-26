const mongoose = require("mongoose");

const TransactionSchema = new mongoose.Schema({  
  botName: { type: String, require: true },
  amount: { type: Number, require: true },
  tx_ref: { type: String, require: true },
  payment_method: {type: String, require: true},
  reference: {type: String, require: true},
  created_at: {type: String, require: true},
  timeStamp: { type: Date, require: true },
});

module.exports = mongoose.model("Transaction", TransactionSchema);
