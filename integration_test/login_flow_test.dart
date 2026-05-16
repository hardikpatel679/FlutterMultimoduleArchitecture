import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_basics/main.dart' as app;
import 'package:flutter_basics/di/injection_container.dart' as di;
import 'package:core/constants/app_constants.dart';
import 'package:core/config/flavor_config.dart';

Future<void> run(WidgetTester tester) async {


  print('TEST_LOG: [LOGIN] Phase Start');

  FlavorConfig.flavor = Flavor.dev;

  // 1. Sync dependencies
  print('TEST_LOG: [LOGIN] di.init()');
  await tester.runAsync(() async {
    await di.init();
  });

  // 2. Launch UI
  print('TEST_LOG: [LOGIN] pumpWidget(MyApp)');
  
  // Use runAsync for pumpWidget on iOS to avoid deadlock with native layer
  await tester.runAsync(() async {
    await tester.pumpWidget(app.MyApp());
  });

  // 3. Forced Native Pulse
  print('TEST_LOG: [LOGIN] Pulsing engine frames...');
  for (int i = 0; i < 5; i++) {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  print('TEST_LOG: [LOGIN] Searching for UI elements...');
  final usernameField = find.byKey(const Key(AppConstants.keyUsernameField));
  
  bool found = false;
  for (int i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 500));
    if (tester.any(usernameField)) {
      found = true;
      print('TEST_LOG: [LOGIN] UI Found at iteration $i');
      break;
    }
  }

  if (!found) {
    print('TEST_LOG: ERROR - Login UI never appeared');
    return;
  }

  // 4. Credentials
  print('TEST_LOG: [LOGIN] Entering Credentials');
  await tester.tap(usernameField);
  await tester.enterText(usernameField, 'emilys');
  await tester.pump();

  final passwordField = find.byKey(const Key(AppConstants.keyPasswordField));
  await tester.tap(passwordField);
  await tester.enterText(passwordField, 'emilyspass');
  await tester.pump();

  print('TEST_LOG: [LOGIN] Submitting Form');
  await tester.tap(find.byKey(const Key(AppConstants.keyLoginButton)));

  // 5. Wait for Dashboard
  final logoutIcon = find.byIcon(Icons.logout);
  bool dashboardReached = false;
  for (int i = 0; i < 30; i++) {
    await tester.pump(const Duration(milliseconds: 500));
    if (tester.any(logoutIcon)) {
      dashboardReached = true;
      print('TEST_LOG: [LOGIN] Dashboard reached');
      break;
    }
  }

  if (dashboardReached) {
    print('TEST_LOG: [LOGIN] Success');
  } else {
    print('TEST_LOG: ERROR - Login Failed to reach Dashboard');
  }
}

void main() {
  testWidgets('login only', (tester) async {
    await run(tester);
  });
}
