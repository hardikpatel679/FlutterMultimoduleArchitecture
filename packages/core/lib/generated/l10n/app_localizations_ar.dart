// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'اتصال';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get loginSubtitle => 'قم بتسجيل الدخول لمواصلة رحلتك.';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get usernameHint => 'emilys';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'هل نسيت كلمة السر؟';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get orContinueWith => 'أو الاستمرار مع';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get signUp => 'اشتراك';

  @override
  String loginSuccessful(String name) {
    return 'تم تسجيل الدخول بنجاح! أهلاً $name';
  }

  @override
  String get dashboardTitle => 'لوحة القيادة';

  @override
  String get welcomeDashboard => 'مرحبا بكم في لوحة القيادة!';

  @override
  String get dashboardInputLabel => 'إدخال لوحة القيادة';

  @override
  String get dashboardInputHint => 'أدخل شيئاً ما...';

  @override
  String get loginSuccessSubtitle => 'لقد قمت بتسجيل الدخول بنجاح.';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String errorMessage(String message) {
    return 'خطأ: $message';
  }

  @override
  String liveUpdates(Object count) {
    return 'التحديثات المباشرة: $count';
  }

  @override
  String batteryLevel(int level) {
    return 'مستوى البطارية: $level%';
  }

  @override
  String get resetStream => 'إعادة تعيين التدفق';

  @override
  String get toggleLanguage => 'تبديل اللغة';

  @override
  String get errUnauthorized =>
      'اسم المستخدم أو كلمة المرور غير صالحة. يرجى المحاولة مرة أخرى.';

  @override
  String get errNetwork => 'لا يوجد اتصال بالإنترنت. يرجى التحقق من إعداداتك.';

  @override
  String get errServer => 'الخادم غير متاح حاليا. يرجى المحاولة لاحقا.';

  @override
  String get errNotFound => 'لم يتم العثور على المورد المطلوب.';

  @override
  String get errUnexpected => 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';

  @override
  String get errMapping => 'خطأ في تعيين البيانات: ';

  @override
  String get errValidation => 'يرجى إدخال اسم المستخدم وكلمة المرور';
}
