import 'package:get_it/get_it.dart';
import '../login/login_viewmodel.dart';
import '../dashboard/dashboard_viewmodel.dart';

Future<void> initLoginInjection(GetIt sl) async {
  sl.registerFactory(() => LoginViewModel(loginUseCase: sl()));
  sl.registerFactory(() => DashboardViewModel());
}
