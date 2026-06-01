import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/widgets/custom_text_field.dart';

void main() {
  group('CustomTextField', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    testWidgets('should render labels and hint correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CustomTextField(
            controller: controller,
            labelText: 'Username',
            hintText: 'Enter username',
          ),
        ),
      ));

      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Enter username'), findsOneWidget);
    });

    testWidgets('should update controller when text is entered', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CustomTextField(
            controller: controller,
            labelText: 'Field',
          ),
        ),
      ));

      await tester.enterText(find.byType(TextFormField), 'Hello');
      expect(controller.text, 'Hello');
    });

    testWidgets('should show prefix icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CustomTextField(
            controller: controller,
            labelText: 'Icon',
            prefixIcon: Icons.person,
          ),
        ),
      ));

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should obscure text when obscureText is true', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CustomTextField(
            controller: controller,
            labelText: 'Password',
            obscureText: true,
          ),
        ),
      ));

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, true);
    });
  });
}
