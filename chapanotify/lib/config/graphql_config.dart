import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlConfig {
  static HttpLink httpLink = HttpLink('http://192.168.80.138:5050/graphql');

  static ValueNotifier<GraphQLClient> initClient() {
    return ValueNotifier(GraphQLClient(link: httpLink, cache: GraphQLCache()));
  }

  static GraphQLClient clientToQuery() {
    return GraphQLClient(link: httpLink, cache: GraphQLCache());
  }
}
