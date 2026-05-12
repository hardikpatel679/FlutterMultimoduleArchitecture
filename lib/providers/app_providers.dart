import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_basics/di/injection_container.dart' as di;
import 'package:core/viewmodels/locale_viewmodel.dart';
import 'package:login_module/login/login_viewmodel.dart';
import 'package:login_module/dashboard/dashboard_viewmodel.dart';

class AppProviders {
  static List<SingleChildWidget> get providers => [
        ChangeNotifierProvider(create: (_) => di.sl<LocaleViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<LoginViewModel>()),
        ChangeNotifierProvider(create: (_) => di.sl<DashboardViewModel>()),
      ];
}
