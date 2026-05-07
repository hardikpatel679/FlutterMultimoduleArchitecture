import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

Future<void> initCoreInjection(GetIt sl) async {
  sl.registerLazySingleton(() => Dio());
}
