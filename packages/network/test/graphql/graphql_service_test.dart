import 'package:flutter_test/flutter_test.dart';
import 'package:network/graphql/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  group('GraphQLService', () {
    const httpUri = 'http://test.com';
    const wsUri = 'ws://test.com';
    late GraphQLService service;

    setUp(() {
      service = GraphQLService(httpUri: httpUri, wsUri: wsUri);
    });

    test('getClient should return a GraphQLClient', () {
      final client = service.getClient();
      expect(client, isA<GraphQLClient>());
      expect(client.link, isA<Link>());
    });

    test('subscribe should return a stream', () {
      final stream = service.subscribe(SubscriptionOptions(document: gql('subscription { test }')));
      expect(stream, isA<Stream<QueryResult>>());
    });
  });
}
