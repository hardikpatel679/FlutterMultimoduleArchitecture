import 'package:get_it/get_it.dart';
import '../usecases/login_usecase.dart';

Future<void> initDomainInjection(GetIt sl) async {
  sl.registerLazySingleton(() => LoginUseCase(sl()));
}
