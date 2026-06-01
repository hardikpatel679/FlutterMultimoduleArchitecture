import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:network/di/network_injection.dart';
import 'package:dio/dio.dart';
import 'package:network/graphql/graphql_service.dart';
import 'package:network/data/datasources/auth_remote_data_source.dart';
import 'package:domain/repositories/login_repository.dart';

void main() {
  final sl = GetIt.instance;

  test('initNetworkInjection should register all dependencies', () async {
    // Register dependencies needed by network
    sl.registerLazySingleton<Dio>(() => Dio());

    await initNetworkInjection(sl);

    expect(sl.isRegistered<GraphQLService>(), isTrue);
    expect(sl.isRegistered<AuthRemoteDataSource>(), isTrue);
    expect(sl.isRegistered<LoginRepository>(), isTrue);

    await sl.reset();
  });
}
