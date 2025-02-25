import 'package:chapanotify/config/graphql_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlService {
  final _getTransactionsQuery = r""" 
    query {
      getTransactions {
        id
        botName
        amount
        tx_ref
        timeStamp
      }
    }
  """;

  Future<List<Map<String, dynamic>>> getTransaction() async {
    final QueryOptions options = QueryOptions(
      document: gql(_getTransactionsQuery),
    );
    final GraphQLClient client = GraphqlConfig.clientToQuery();

    try {
      final result = await client.query(options);

      if (result.hasException) {
        throw Exception(
          'Failed to fetch transactions: ${result.exception.toString()}',
        );
      }

      List transactions = result.data?['getTransactions'] ?? '';

      return List<Map<String, dynamic>>.from(transactions);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
