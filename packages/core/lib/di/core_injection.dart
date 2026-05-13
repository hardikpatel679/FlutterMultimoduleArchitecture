import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../viewmodels/locale_viewmodel.dart';
import '../services/battery_service.dart';

Future<void> initCoreInjection(GetIt sl) async {
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LocaleViewModel());
  sl.registerLazySingleton(() => BatteryService());
}
