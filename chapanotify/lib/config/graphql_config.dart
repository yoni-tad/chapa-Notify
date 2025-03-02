import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlConfig {
  static HttpLink httpLink = HttpLink(
    'YOUR-GRAPHQL-ENDPOINT',
    defaultHeaders: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
  );

  static ValueNotifier<GraphQLClient> initClient() {
    return ValueNotifier(GraphQLClient(link: httpLink, cache: GraphQLCache()));
  }

  static GraphQLClient clientToQuery() {
    return GraphQLClient(link: httpLink, cache: GraphQLCache());
  }
}
