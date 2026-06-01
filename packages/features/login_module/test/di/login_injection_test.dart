import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:login_module/di/login_injection.dart';
import 'package:login_module/login/login_viewmodel.dart';
import 'package:login_module/dashboard/dashboard_viewmodel.dart';
import 'package:mocktail/mocktail.dart';
import 'package:domain/usecases/login_usecase.dart';
import 'package:core/services/battery_service.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockBatteryService extends Mock implements BatteryService {}

void main() {
  final sl = GetIt.instance;

  test('initLoginInjection should register all dependencies', () async {
    // Register dependencies needed by features
    sl.registerLazySingleton<LoginUseCase>(() => MockLoginUseCase());
    sl.registerLazySingleton<BatteryService>(() => MockBatteryService());

    await initLoginInjection(sl);

    expect(sl.isRegistered<LoginViewModel>(), isTrue);
    expect(sl.isRegistered<DashboardViewModel>(), isTrue);

    await sl.reset();
  });
}
