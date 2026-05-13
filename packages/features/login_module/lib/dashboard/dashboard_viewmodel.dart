import 'dart:async';
import 'package:core/viewmodels/base_stream_view_model.dart';
import 'package:core/services/battery_service.dart';

class DashboardViewModel extends BaseStreamViewModel<int> {
  final BatteryService _batteryService;

  DashboardViewModel({required BatteryService batteryService}) 
      : _batteryService = batteryService;

  int? _batteryLevel;
  int? get batteryLevel => _batteryLevel;

  Future<void> fetchBatteryLevel() async {
    try {
      _batteryLevel = await _batteryService.getBatteryLevel();
      notifyListeners();
    } catch (e) {
      // Handle error if needed
    }
  }

  /// In a real app, this would come from a Repository via a GraphQL Subscription or WebSocket.
  @override
  Stream<int> getStream() {
    return Stream.periodic(const Duration(seconds: 1), (count) => count).take(100);
  }

  /// Optional: You can add specific business logic here
  void resetDashboard() {
    disconnect();
    connect();
    fetchBatteryLevel();
  }
}
