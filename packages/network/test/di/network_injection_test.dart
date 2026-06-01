import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:network/di/network_injection.dart';
import 'package:dio/dio.dart';
import 'package:network/graphql/graphql_service.dart';
import 'package:network/data/datasources/auth_remote_data_source.dart';
import 'package:domain/repositories/login_repository.dart';
import 'package:core/config/flavor_config.dart';

void main() {
  final sl = GetIt.instance;

  test('initNetworkInjection should register all dependencies and handle mock flavor', () async {
    // Set flavor to mock to hit the interceptor branch
    FlavorConfig.flavor = Flavor.mock;
    
    // Register dependencies needed by network
    final dio = Dio();
    sl.registerLazySingleton<Dio>(() => dio);

    await initNetworkInjection(sl);

    expect(sl.isRegistered<GraphQLService>(), isTrue);
    expect(sl.isRegistered<AuthRemoteDataSource>(), isTrue);
    expect(sl.isRegistered<LoginRepository>(), isTrue);
    
    // Verify interceptor was added (1 logger + 1 mock interceptor)
    expect(dio.interceptors.isNotEmpty, isTrue);

    await sl.reset();
    // Reset flavor
    FlavorConfig.flavor = Flavor.dev;
  });
}
