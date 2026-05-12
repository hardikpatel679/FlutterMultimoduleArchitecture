import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  final String httpUri;
  final String wsUri;

  GraphQLService({required this.httpUri, required this.wsUri});

  GraphQLClient getClient() {
    final HttpLink httpLink = HttpLink(httpUri);
    final WebSocketLink wsLink = WebSocketLink(wsUri);

    final Link link = Link.split(
      (request) => request.isSubscription,
      wsLink,
      httpLink,
    );

    return GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  /// Helper to get a stream from a GraphQL Subscription
  Stream<QueryResult> subscribe(SubscriptionOptions options) {
    return getClient().subscribe(options);
  }
}
