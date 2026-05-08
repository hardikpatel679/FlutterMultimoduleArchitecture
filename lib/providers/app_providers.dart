import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_basics/di/injection_container.dart' as di;
import 'package:auth/login/login_viewmodel.dart';

class AppProviders {
  static List<SingleChildWidget> get providers => [
        ChangeNotifierProvider(create: (_) => di.sl<LoginViewModel>()),
        // As you add more features, add their ViewModels here
      ];
}
