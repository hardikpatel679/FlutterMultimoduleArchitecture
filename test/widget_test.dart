import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_basics/main.dart';
import 'package:flutter_basics/di/injection_container.dart' as di;
import 'package:core/constants/app_strings.dart';
import 'package:get_it/get_it.dart';

void main() {
  setUp(() async {
    // Reset GetIt and re-initialize for tests
    await GetIt.instance.reset();
    await di.init();
  });

  testWidgets('App should load and show login_module page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the login_module page elements are present.
    expect(find.text(AppStrings.welcomeBack), findsOneWidget);
    expect(find.text(AppStrings.login), findsOneWidget);
  });
}
