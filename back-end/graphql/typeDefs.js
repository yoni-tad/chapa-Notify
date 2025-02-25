const { gql } = require("apollo-server-express");

const typeDefs = gql`
    type Transaction {
        id: ID!
        botName: String!
        amount: Float!
        tx_ref: String!
        timeStamp: String!
    }

    type Query {
        getTransactions: [Transaction]
    }

    type Mutation {
        addTransaction(
            botName: String!,
            amount: Float!,
            tx_ref: String!,
        ): Transaction
    }
`;

module.exports = typeDefs;