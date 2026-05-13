// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CONNECT';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get loginSubtitle => 'Log in to continue your journey.';

  @override
  String get username => 'Username';

  @override
  String get usernameHint => 'emilys';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get login => 'Log In';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String loginSuccessful(String name) {
    return 'Login Successful! Welcome $name';
  }

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get welcomeDashboard => 'Welcome to the Dashboard!';

  @override
  String get loginSuccessSubtitle => 'You have successfully logged in.';

  @override
  String get logout => 'Logout';

  @override
  String errorMessage(String message) {
    return 'Error: $message';
  }

  @override
  String liveUpdates(Object count) {
    return 'Live Updates: $count';
  }

  @override
  String batteryLevel(int level) {
    return 'Battery Level: $level%';
  }

  @override
  String get resetStream => 'Reset Stream';

  @override
  String get toggleLanguage => 'Toggle Language';

  @override
  String get errUnauthorized =>
      'Invalid username or password. Please try again.';

  @override
  String get errNetwork =>
      'No internet connection. Please check your settings.';

  @override
  String get errServer =>
      'The server is currently unavailable. Please try later.';

  @override
  String get errNotFound => 'The requested resource was not found.';

  @override
  String get errUnexpected => 'An unexpected error occurred. Please try again.';

  @override
  String get errMapping => 'Data mapping error: ';

  @override
  String get errValidation => 'Please enter both username and password';
}
