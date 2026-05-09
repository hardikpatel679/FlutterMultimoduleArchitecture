import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:core/config/flavor_config.dart';
import 'package:domain/repositories/login_repository.dart';
import '../constants/mock_paths.dart';
import '../data/datasources/auth_remote_data_source.dart';
import '../data/datasources/impl/auth_remote_data_source_impl.dart';
import '../data/repositories/login_repository_impl.dart';
import '../interceptors/mock_interceptor.dart';

Future<void> initNetworkInjection(GetIt sl) async {
  final dio = sl<Dio>();
  
  if (kDebugMode) {
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));
  }

  // Inject the centralized mock mappings if in mock flavor
  if (FlavorConfig.isMock) {
    dio.interceptors.add(MockInterceptor(
      mockMappings: MockPaths.mappings,
    ));
  }

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(remoteDataSource: sl()),
  );
}
