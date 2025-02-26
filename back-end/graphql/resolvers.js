const Transaction = require("./../model/transaction");
const moment = require("moment");

const resolvers = {
  Query: {
    getTransactions: async (_, { filter }) => {
      let query = {};
      const todayStart = moment().startOf("day").toDate();
      const todayEnd = moment().endOf("day").toDate();
      const weekStart = moment().startOf("week").toDate();
      const weekEnd = moment().endOf("week").toDate();
      const monthStart = moment().startOf("month").toDate();
      const monthEnd = moment().endOf("month").toDate();

      if (filter === "today") {
        query.timeStamp = { $gte: todayStart, $lte: todayEnd };
      } else if (filter === "this_week") {
        query.timeStamp = { $gte: weekStart, $lte: weekEnd };
      } else if (filter === "this_month") {
        query.timeStamp = { $gte: monthStart, $lte: monthEnd };
      }

      console.log("MongoDB Query:", query);
      const transactions = await Transaction.find(query);
      console.log("Fetched Transactions:", transactions);

      return transactions;
    },
  },

  Mutation: {
    addTransaction: async (_, { botName, amount }) => {
      const newTransaction = new Transaction({
        botName,
        amount,
        tx_ref,
        payment_method,
        reference,
        created_at,
        timeStamp: new Date().toISOString(),
      });
      await newTransaction.save();
      return newTransaction;
    },
  },
};

module.exports = resolvers;
