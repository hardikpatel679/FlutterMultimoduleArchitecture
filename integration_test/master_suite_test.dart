import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'login_flow_test.dart' as login;
import 'dashboard_flow_test.dart' as dashboard;

void main() {
  debugPrint('TEST_LOG: [MASTER] Initializing Integration Binding');
  
  // Initialize the binding
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  // fullyLive is required for standard interactions and to avoid hangs on iOS
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('Full App Journey: Login -> Dashboard -> Logout', (WidgetTester tester) async {
    debugPrint('TEST_LOG: [MASTER] Full Journey Start');

    // Part 1: Login
    await login.run(tester);

    // Part 2: Dashboard Features
    await dashboard.run(tester);

    debugPrint('TEST_LOG: [MASTER] Full Regression Suite completed successfully!');
  });
}
