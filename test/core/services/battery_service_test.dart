import 'package:flutter_test/flutter_test.dart';
import 'package:core/services/battery_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late BatteryService batteryService;

  setUp(() {
    batteryService = BatteryService();
  });

  test('getBatteryLevel should return an integer', () async {
    // We cannot easily mock the internal Battery() instance without DI,
    // so we just verify it returns a value (on most systems it returns a dummy or real value)
    final level = await batteryService.getBatteryLevel();
    expect(level, isA<int>());
  });
}
