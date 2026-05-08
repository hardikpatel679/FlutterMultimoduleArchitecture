import 'package:auth/login/login_page.dart';
import 'package:auth/login/login_viewmodel.dart';
import 'package:core/constants/app_strings.dart';
import 'package:core/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'login_page_test.mocks.dart';

@GenerateMocks([LoginViewModel])

void main() {
  late MockLoginViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockLoginViewModel();
  });

  Widget createWidget() {
    return ChangeNotifierProvider<LoginViewModel>.value(
      value: mockViewModel,
      child: const MaterialApp(
        home: LoginPage(),
      ),
    );
  }

  testWidgets('UI renders correctly', (WidgetTester tester) async {
    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.user).thenReturn(null);
    when(mockViewModel.errorMessage).thenReturn(null);

    await tester.pumpWidget(createWidget());

    expect(find.text(AppStrings.login), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('✅ User can enter username & password', (tester) async {
    final mockViewModel = MockLoginViewModel();

    // ✅ Stub ALL required properties
    when(mockViewModel.isLoading).thenReturn(false);
    when(mockViewModel.user).thenReturn(null);
    when(mockViewModel.errorMessage).thenReturn(null);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<LoginViewModel>.value(
          value: mockViewModel,
          child: const LoginPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // ✅ Use correct keys from AppStrings
    final usernameField = find.byKey(Key(AppStrings.username));
    final passwordField = find.byKey(Key(AppStrings.password));

    expect(usernameField, findsOneWidget);
    expect(passwordField, findsOneWidget);

    // ✅ Enter text
    await tester.enterText(usernameField, 'emilys');
    await tester.enterText(passwordField, 'password');

    // ✅ Verify text entered
    expect(find.text('emilys'), findsWidgets); // ⚠️ not findsOneWidget
  });

    testWidgets('Login button triggers ViewModel login',
          (WidgetTester tester) async {

        when(mockViewModel.isLoading).thenReturn(false);

        // 👇 IMPORTANT FIX
        when(mockViewModel.user).thenReturn(null);
        when(mockViewModel.errorMessage).thenReturn(null);

        when(mockViewModel.login('emilys', 'password123'))
            .thenAnswer((_) async {});

        await tester.pumpWidget(createWidget());

        await tester.enterText(find.byType(TextField).at(0), 'emilys');
        await tester.enterText(find.byType(TextField).at(1), 'password123');

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        verify(mockViewModel.login('emilys', 'password123')).called(1);
      });

  testWidgets('✅ Shows loading indicator when isLoading is true',
          (WidgetTester tester) async {
        when(mockViewModel.isLoading).thenReturn(true);

        await tester.pumpWidget(createWidget());

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

  testWidgets('✅ Shows success Snackbar on login success',
          (WidgetTester tester) async {
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.user).thenReturn(
          User(
            id: 1,
            username: 'emilys',
            email: 'emily@test.com',
            firstName: 'Emily',
            lastName: 'Smith',
            gender: 'female',
            image: 'https://dummy.com/image.png',
            token: 'token_123',
          ), // Replace with your actual model
        );
        when(mockViewModel.errorMessage).thenReturn(null);
        when(mockViewModel.login(any, any))
            .thenAnswer((_) async {});

        await tester.pumpWidget(createWidget());

        await tester.enterText(find.byType(TextField).at(0), 'emilys');
        await tester.enterText(find.byType(TextField).at(1), 'emilyspass');

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump(); // trigger rebuild
        await tester.pump(const Duration(seconds: 1)); // snackbar animation

        expect(find.byType(SnackBar), findsOneWidget);
      });

  testWidgets('❌ Shows error Snackbar on login failure',
          (WidgetTester tester) async {
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.user).thenReturn(null);
        when(mockViewModel.errorMessage).thenReturn('Invalid credentials');
        when(mockViewModel.login(any, any))
            .thenAnswer((_) async {});

        await tester.pumpWidget(createWidget());

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));

        expect(find.text('Invalid credentials'), findsOneWidget);
      });
}