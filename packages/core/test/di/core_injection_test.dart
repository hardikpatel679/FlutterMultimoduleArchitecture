import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:core/di/core_injection.dart';
import 'package:dio/dio.dart';
import 'package:core/viewmodels/locale_viewmodel.dart';
import 'package:core/services/battery_service.dart';

void main() {
  final sl = GetIt.instance;

  test('initCoreInjection should register all dependencies', () async {
    await initCoreInjection(sl);

    expect(sl.isRegistered<Dio>(), isTrue);
    expect(sl.isRegistered<LocaleViewModel>(), isTrue);
    expect(sl.isRegistered<BatteryService>(), isTrue);

    await sl.reset();
  });
}
