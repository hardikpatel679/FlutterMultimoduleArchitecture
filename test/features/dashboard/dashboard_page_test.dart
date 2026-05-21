import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:login_module/dashboard/dashboard_page.dart';
import 'package:login_module/dashboard/dashboard_viewmodel.dart';
import 'package:login_module/login/login_viewmodel.dart';
import 'package:core/viewmodels/locale_viewmodel.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:core/generated/l10n/app_localizations.dart';

class MockDashboardViewModel extends Mock implements DashboardViewModel {}
class MockLoginViewModel extends Mock implements LoginViewModel {}
class MockLocaleViewModel extends Mock implements LocaleViewModel {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockDashboardViewModel mockDashboardViewModel;
  late MockLoginViewModel mockLoginViewModel;
  late MockLocaleViewModel mockLocaleViewModel;
  late MockNavigatorObserver mockNavigatorObserver;

  setUpAll(() {
    registerFallbackValue(MaterialPageRoute(builder: (_) => Container()));
  });

  setUp(() {
    mockDashboardViewModel = MockDashboardViewModel();
    mockLoginViewModel = MockLoginViewModel();
    mockLocaleViewModel = MockLocaleViewModel();
    mockNavigatorObserver = MockNavigatorObserver();

    // Default stubs
    when(() => mockDashboardViewModel.isLoading).thenReturn(false);
    when(() => mockDashboardViewModel.data).thenReturn(0);
    when(() => mockDashboardViewModel.error).thenReturn(null);
    when(() => mockDashboardViewModel.batteryLevel).thenReturn(null);
    when(() => mockDashboardViewModel.connect()).thenReturn(null);
    when(() => mockDashboardViewModel.disconnect()).thenReturn(null);
    when(() => mockDashboardViewModel.resetDashboard()).thenReturn(null);
    when(() => mockDashboardViewModel.fetchBatteryLevel()).thenAnswer((_) async {});
    when(() => mockDashboardViewModel.inputController).thenReturn(TextEditingController());
    
    when(() => mockLoginViewModel.logout()).thenReturn(null);
    when(() => mockLoginViewModel.isPasswordVisible).thenReturn(false);
    when(() => mockLoginViewModel.isLoading).thenReturn(false);
    when(() => mockLoginViewModel.user).thenReturn(null);
    when(() => mockLoginViewModel.errorMessage).thenReturn(null);
    when(() => mockLoginViewModel.usernameController).thenReturn(TextEditingController());
    when(() => mockLoginViewModel.passwordController).thenReturn(TextEditingController());
    
    when(() => mockLocaleViewModel.locale).thenReturn(const Locale('en'));
    when(() => mockLocaleViewModel.toggleLocale()).thenReturn(null);
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DashboardViewModel>.value(value: mockDashboardViewModel),
        ChangeNotifierProvider<LoginViewModel>.value(value: mockLoginViewModel),
        ChangeNotifierProvider<LocaleViewModel>.value(value: mockLocaleViewModel),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        navigatorObservers: [mockNavigatorObserver],
        home: const DashboardPage(),
      ),
    );
  }

  group('DashboardPage', () {
    // Removed 'should call connect and fetchBatteryLevel on init' test 
    // because that responsibility moved to the ViewModel constructor.

    testWidgets('should display battery level when available', (WidgetTester tester) async {
      when(() => mockDashboardViewModel.batteryLevel).thenReturn(75);
      
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(); // Ensure translations are loaded

      expect(find.textContaining('75%'), findsOneWidget);
    });

    testWidgets('should display live updates data', (WidgetTester tester) async {
      when(() => mockDashboardViewModel.data).thenReturn(42);
      
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.textContaining('42'), findsOneWidget);
    });

    testWidgets('should show circular progress when loading', (WidgetTester tester) async {
      when(() => mockDashboardViewModel.isLoading).thenReturn(true);
      
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should call logout and navigate back when logout is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      verify(() => mockDashboardViewModel.disconnect()).called(1);
      verify(() => mockLoginViewModel.logout()).called(1);
      
      // Verify navigation occurred
      verify(() => mockNavigatorObserver.didPush(any(), any())).called(greaterThan(0));
    });

    testWidgets('should call toggleLocale when language button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Tap the Toggle Language button (found by text)
      await tester.tap(find.text('Toggle Language'));
      await tester.pump();

      verify(() => mockLocaleViewModel.toggleLocale()).called(1);
    });
  });
}
