import 'dart:async';
import 'package:core/viewmodels/base_stream_view_model.dart';

class DashboardViewModel extends BaseStreamViewModel<int> {
  /// In a real app, this would come from a Repository via a GraphQL Subscription or WebSocket.
  @override
  Stream<int> getStream() {
    return Stream.periodic(const Duration(seconds: 1), (count) => count).take(100);
  }

  /// Optional: You can add specific business logic here
  void resetDashboard() {
    disconnect();
    connect();
  }
}
