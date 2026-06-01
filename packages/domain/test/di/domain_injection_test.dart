import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:domain/di/domain_injection.dart';
import 'package:domain/usecases/login_usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:domain/repositories/login_repository.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

void main() {
  final sl = GetIt.instance;

  test('initDomainInjection should register all dependencies', () async {
    // Register dependencies needed by domain usecases
    sl.registerLazySingleton<LoginRepository>(() => MockLoginRepository());

    await initDomainInjection(sl);

    expect(sl.isRegistered<LoginUseCase>(), isTrue);

    await sl.reset();
  });
}
