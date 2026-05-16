import 'package:get_it/get_it.dart';
import 'package:core/viewmodels/locale_viewmodel.dart';
import 'package:core/di/core_injection.dart';
import 'package:domain/di/domain_injection.dart';
import 'package:network/di/network_injection.dart';
import 'package:login_module/di/login_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Safe Reset: Only reset if GetIt has been initialized before
  if (sl.isRegistered<LocaleViewModel>()) {
    await sl.reset();
  }

  // Initialize Core injection
  await initCoreInjection(sl);
  
  // Initialize Domain injection
  await initDomainInjection(sl);
  
  // Initialize Network injection
  await initNetworkInjection(sl);
  
  // Initialize Login feature injection
  await initLoginInjection(sl);
}
