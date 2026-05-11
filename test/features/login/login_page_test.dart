import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:login_module/login/login_page.dart';
import 'package:login_module/login/login_viewmodel.dart';
import 'package:core/constants/app_strings.dart';
import 'package:core/errors/app_exceptions.dart';
import 'package:domain/usecases/login_usecase.dart';
import '../../helpers/test_helper.dart';

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
      home: ChangeNotifierProvider<LoginViewModel>.value(
        value: viewModel,
        child: const LoginPage(),
      ),
    );
  }

  // Use the actual JSON data for the test user
  final tUser = TestHelper.getUserFromMockJson();

  group('LoginPage', () {
    testWidgets('should show success snackbar using data from JSON on successful login_module', (WidgetTester tester) async {
      // Arrange
      viewModel.usernameController.text = 'emilys';
      viewModel.passwordController.text = 'emilyspass';
      
      when(() => mockLoginUseCase.execute(any(), any()))
          .thenAnswer((_) async => tUser);

      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      await tester.tap(find.text(AppStrings.login));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining(AppStrings.loginSuccessful), findsOneWidget);
      expect(find.textContaining(tUser.firstName), findsOneWidget); // Verifies 'Emily' from JSON
    });

    testWidgets('should show error snackbar when login_module fails', (WidgetTester tester) async {
      // Arrange
      viewModel.usernameController.text = 'emilys';
      viewModel.passwordController.text = 'wrong';
      
      when(() => mockLoginUseCase.execute(any(), any()))
          .thenThrow(UnauthorizedException());

      await tester.pumpWidget(createWidgetUnderTest());

      // Act
      await tester.tap(find.text(AppStrings.login));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Invalid username or password'), findsOneWidget);
    });

    testWidgets('should update ViewModel controllers when typing', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byKey(const Key(AppStrings.username)), 'newuser');
      await tester.enterText(find.byKey(const Key(AppStrings.password)), 'newpass');

      expect(viewModel.usernameController.text, 'newuser');
      expect(viewModel.passwordController.text, 'newpass');
    });

    testWidgets('should toggle password visibility when icon is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the password text field
      final passwordField = tester.widget<TextField>(
        find.descendant(
          of: find.byKey(const Key(AppStrings.password)),
          matching: find.byType(TextField),
        ),
      );

      // Verify it's initially obscured
      expect(passwordField.obscureText, true);

      // Find and tap the visibility toggle icon
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();

      // Find the field again to check updated state
      final passwordFieldUpdated = tester.widget<TextField>(
        find.descendant(
          of: find.byKey(const Key(AppStrings.password)),
          matching: find.byType(TextField),
        ),
      );

      // Verify it's now visible
      expect(passwordFieldUpdated.obscureText, false);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Tap again to hide
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      final passwordFieldHiddenAgain = tester.widget<TextField>(
        find.descendant(
          of: find.byKey(const Key(AppStrings.password)),
          matching: find.byType(TextField),
        ),
      );
      expect(passwordFieldHiddenAgain.obscureText, true);
    });
  });
}
