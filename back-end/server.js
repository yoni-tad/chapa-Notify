const express = require("express");
const cors = require("cors");
const mongoose = require("mongoose");
const { ApolloServer } = require("apollo-server-express");
const route = require("./router/webhook");

require("dotenv").config();

const app = express();
app.use(cors());


app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use('/api', route);

const typeDefs = require("./graphql/typeDefs");
const resolvers = require("./graphql/resolvers");

// setup apollo server
async function startServer() {
  const server = new ApolloServer({ typeDefs, resolvers });
  await server.start();
  server.applyMiddleware({ app });
  console.log(`✅ Apollo server start: ${server.graphqlPath}`);
}

const port = process.env.port || 4040;
(async () => {
  try {
    await mongoose.connect(process.env.MONGO_DB);
    console.log("✅ Mongo db successfully connected");

    app.listen(port, () => {
      console.log(`✅ Server start at: ${port}`);
    });
    startServer();
  } catch (e) {
    console.error("❌ Server error:", e.message);
  }
})();
