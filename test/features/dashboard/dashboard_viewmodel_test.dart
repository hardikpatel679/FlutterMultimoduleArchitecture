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
    // Stub before constructor call
    when(() => mockBatteryService.getBatteryLevel()).thenAnswer((_) async => 85);
  });

  group('DashboardViewModel', () {
    test('initial state should be correct and auto-initialize', () {
      // Act
      viewModel = DashboardViewModel(batteryService: mockBatteryService);

      // Assert: connect() sets isLoading to true
      expect(viewModel.isLoading, true);
      expect(viewModel.data, null);
      expect(viewModel.error, null);
      
      // verify auto-calls
      verify(() => mockBatteryService.getBatteryLevel()).called(1);
    });

    test('fetchBatteryLevel should update batteryLevel', () async {
      // Arrange
      viewModel = DashboardViewModel(batteryService: mockBatteryService);
      when(() => mockBatteryService.getBatteryLevel()).thenAnswer((_) async => 90);

      // Act
      await viewModel.fetchBatteryLevel();

      // Assert
      expect(viewModel.batteryLevel, 90);
    });

    test('connect should start streaming data', () async {
      // Arrange
      viewModel = DashboardViewModel(batteryService: mockBatteryService);

      // Assert: Initially it should be loading (from constructor auto-init)
      expect(viewModel.isLoading, true);

      // Wait for the first periodic value (1s delay)
      await Future.delayed(const Duration(milliseconds: 1100));

      expect(viewModel.data, 0);
      expect(viewModel.isLoading, false);
    });

    test('resetDashboard should reconnect the stream and fetch battery', () async {
      // Arrange
      when(() => mockBatteryService.getBatteryLevel()).thenAnswer((_) async => 100);
      viewModel = DashboardViewModel(batteryService: mockBatteryService);
      
      // Wait for initial data
      await Future.delayed(const Duration(milliseconds: 1100));
      expect(viewModel.data, 0);

      // Act
      viewModel.resetDashboard();
      
      // Assert: Should be loading again
      expect(viewModel.isLoading, true);
      
      await Future.delayed(const Duration(milliseconds: 1100));
      expect(viewModel.data, 0); // New stream starts at 0
      expect(viewModel.batteryLevel, 100);
    });
  });
}
