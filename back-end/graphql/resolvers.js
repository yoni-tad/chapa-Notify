const Transaction = require("./../model/transaction");

const resolvers = {
  Query: {
    getTransactions: async () => await Transaction.find(),
  },

  Mutation: {
    addTransaction: async (_, { botName, amount }) => {
      const newTransaction = new Transaction({
        botName,
        amount,
        tx_ref,
        timeStamp: new Date().toISOString(),
      });
      await newTransaction.save();
      return newTransaction;
    },
  },
};

module.exports = resolvers;
