import 'package:flutter_test/flutter_test.dart';
import 'package:core/services/battery_service.dart';
import 'package:flutter/services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late BatteryService batteryService;
  const MethodChannel channel = MethodChannel('dev.fluttercommunity.plus/battery');

  setUp(() {
    batteryService = BatteryService();
    
    // Mock the platform channel response
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getBatteryLevel') {
        return 42;
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getBatteryLevel should return an integer', () async {
    final level = await batteryService.getBatteryLevel();
    expect(level, 42);
  });
}
