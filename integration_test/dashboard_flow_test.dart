import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:core/constants/app_constants.dart';

// No main() here, we will use a run function
Future<void> run(WidgetTester tester) async {
  // ignore: non_constant_identifier_names
  final $ = PatrolTester(tester: tester, config: const PatrolTesterConfig());

  print('TEST_LOG: [DASHBOARD] Starting Dashboard Feature Tests');

  // 1. Verify we are on Dashboard
  expect($(Icons.dashboard), findsOneWidget);

  // 2. Test Dashboard Input Field
  final dashboardInput = $(Key(AppConstants.keyDashboardInputField));
  await tester.ensureVisible(dashboardInput);
  await dashboardInput.tap();
  await dashboardInput.enterText('Suite Sequence Content');
  expect(find.text('Suite Sequence Content'), findsOneWidget);

  // 3. Test "Reset Stream" Button
  final resetButton = $('Reset Stream');
  await tester.ensureVisible(resetButton);
  await resetButton.tap();
  expect(find.text('Suite Sequence Content'), findsNothing);

  // 4. Test "Toggle Language" Button (English -> Arabic -> English)
  final toggleButton = $('Toggle Language');
  await tester.ensureVisible(toggleButton);
  print('TEST_LOG: [DASHBOARD] Tapping Toggle Language...');
  await toggleButton.tap();
  
  // Wait for the UI to update
  await tester.pump(const Duration(seconds: 1));
  
  // Arabic check
  final arabicToggle = $('تبديل اللغة');
  await tester.ensureVisible(arabicToggle);
  expect(arabicToggle, findsOneWidget);

  print('TEST_LOG: [DASHBOARD] Tapping Arabic Toggle...');
  await arabicToggle.tap();
  await tester.pump(const Duration(seconds: 1));
  
  // English check
  await tester.ensureVisible(toggleButton);
  expect(toggleButton, findsOneWidget);

  // 5. Final Logout
  print('TEST_LOG: [DASHBOARD] Performing Logout...');
  final logoutIcon = $(Icons.logout);
  await logoutIcon.tap();
  
  // Wait for return to login page
  bool loginReturned = false;
  for (int i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 500));
    if (tester.any(find.byKey(const Key(AppConstants.keyUsernameField)))) {
      loginReturned = true;
      break;
    }
  }
  expect(loginReturned, isTrue);

  print('TEST_LOG: [DASHBOARD] Dashboard tests completed, Logged out');
}

// Keep main for independent execution if needed
void main() {
  testWidgets('dashboard features only', (tester) async {
    print('WARNING: This test depends on login_flow_test if run in a suite');
  });
}
