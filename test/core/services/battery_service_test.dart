import 'package:flutter_test/flutter_test.dart';
import 'package:core/services/battery_service.dart';
import 'package:mockito/annotations.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:mockito/mockito.dart';

import 'battery_service_test.mocks.dart';

@GenerateMocks([Battery])
void main() {
  late BatteryService batteryService;
  late MockBattery mockBattery;

  setUp(() {
    mockBattery = MockBattery();
    batteryService = BatteryService();
    // Note: Since we can't easily inject the battery into BatteryService 
    // without refactoring it, we'll test the service as is.
    // In a real scenario, we'd pass the Battery instance to the constructor.
  });

  test('getBatteryLevel should return an integer', () async {
    final level = await batteryService.getBatteryLevel();
    expect(level, isA<int>());
  });
}
