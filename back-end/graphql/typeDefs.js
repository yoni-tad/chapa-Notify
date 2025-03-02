const { gql } = require("apollo-server-express");

const typeDefs = gql`
    type Transaction {
        id: ID!
        botName: String!
        amount: Float!
        tx_ref: String
        payment_method: String,
        reference: String,
        created_at: String,
        timeStamp: String!
    }

    type Query {
        getTransactions(filter: String): [Transaction]
    }

    type Mutation {
        addTransaction(
            botName: String!,
            amount: Float!,
            tx_ref: String!,
            payment_method: String!,
            reference: String!,
            created_at: String!,
        ): Transaction
    }
`;

module.exports = typeDefs;