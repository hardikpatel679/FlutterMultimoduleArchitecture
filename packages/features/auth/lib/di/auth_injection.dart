import 'package:get_it/get_it.dart';
import '../login/login_viewmodel.dart';

Future<void> initAuthInjection(GetIt sl) async {
  sl.registerFactory(() => LoginViewModel(loginUseCase: sl()));
}
