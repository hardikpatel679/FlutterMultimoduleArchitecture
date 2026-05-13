import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:login_module/dashboard/dashboard_viewmodel.dart';
import 'package:core/services/battery_service.dart';

class MockBatteryService extends Mock implements BatteryService {}

void main() {
  late DashboardViewModel viewModel;
  late MockBatteryService mockBatteryService;

  setUp(() {
    mockBatteryService = MockBatteryService();
    viewModel = DashboardViewModel(batteryService: mockBatteryService);
  });

  group('DashboardViewModel', () {
    test('initial state should be correct', () {
      expect(viewModel.data, null);
      expect(viewModel.isLoading, false);
      expect(viewModel.error, null);
      expect(viewModel.batteryLevel, null);
    });

    test('fetchBatteryLevel should update batteryLevel', () async {
      // Arrange
      when(() => mockBatteryService.getBatteryLevel()).thenAnswer((_) async => 85);

      // Act
      await viewModel.fetchBatteryLevel();

      // Assert
      expect(viewModel.batteryLevel, 85);
      verify(() => mockBatteryService.getBatteryLevel()).called(1);
    });

    test('connect should start streaming data', () async {
      // Act
      viewModel.connect();

      // Assert: Initially it should be loading
      expect(viewModel.isLoading, true);

      // Wait for the first periodic value (1s delay)
      await Future.delayed(const Duration(milliseconds: 1100));

      expect(viewModel.data, 0);
      expect(viewModel.isLoading, false);
      expect(viewModel.error, null);
    });

    test('disconnect should stop streaming data', () async {
      // Arrange
      viewModel.connect();
      await Future.delayed(const Duration(milliseconds: 1100));
      expect(viewModel.data, 0);

      // Act
      viewModel.disconnect();

      // Assert
      expect(viewModel.isLoading, false);
      
      // Wait another second to see if data updates (it shouldn't)
      await Future.delayed(const Duration(milliseconds: 1100));
      expect(viewModel.data, 0); // Still 0, didn't update to 1
    });

    test('resetDashboard should reconnect the stream and fetch battery', () async {
      // Arrange
      when(() => mockBatteryService.getBatteryLevel()).thenAnswer((_) async => 90);
      viewModel.connect();
      await Future.delayed(const Duration(milliseconds: 1100));
      expect(viewModel.data, 0);

      // Act
      viewModel.resetDashboard();
      
      // Assert: Should be loading again
      expect(viewModel.isLoading, true);
      
      await Future.delayed(const Duration(milliseconds: 1100));
      expect(viewModel.data, 0); // New stream starts at 0
      expect(viewModel.isLoading, false);
      expect(viewModel.batteryLevel, 90);
    });
  });
}
