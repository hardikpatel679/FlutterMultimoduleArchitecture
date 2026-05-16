import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:login_module/login/login_page.dart';
import 'package:login_module/login/login_viewmodel.dart';
import 'package:core/generated/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:core/errors/app_exceptions.dart';
import 'package:domain/usecases/login_usecase.dart';


class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late LoginViewModel viewModel;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    viewModel = LoginViewModel(loginUseCase: mockLoginUseCase);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: ChangeNotifierProvider<LoginViewModel>.value(
        value: viewModel,
        child: const LoginPage(),
      ),
    );
  }

  // Use the actual JSON data for the test user
  group('LoginPage', () {
    testWidgets('should show error snackbar when login fails', (WidgetTester tester) async {
      // Arrange
      viewModel.usernameController.text = 'emilys';
      viewModel.passwordController.text = 'wrong';
      
      when(() => mockLoginUseCase.execute(any(), any()))
          .thenThrow(UnauthorizedException());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Wait for localization to load

      // Act
      // Find by type as text might be localized
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('should update ViewModel controllers when typing', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final usernameField = find.byType(TextField).first;
      final passwordField = find.byType(TextField).last;

      await tester.enterText(usernameField, 'newuser');
      await tester.enterText(passwordField, 'newpass');

      expect(viewModel.usernameController.text, 'newuser');
      expect(viewModel.passwordController.text, 'newpass');
    });

    testWidgets('should toggle password visibility when icon is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find the password text field
      final passwordFieldFinder = find.byType(TextField).last;
      TextField passwordField = tester.widget<TextField>(passwordFieldFinder);

      // Verify it's initially obscured
      expect(passwordField.obscureText, true);

      // Find and tap the visibility toggle icon
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();

      // Verify it's now visible
      passwordField = tester.widget<TextField>(passwordFieldFinder);
      expect(passwordField.obscureText, false);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Tap again to hide
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      passwordField = tester.widget<TextField>(passwordFieldFinder);
      expect(passwordField.obscureText, true);
    });
  });
}
