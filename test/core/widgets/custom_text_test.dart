import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/widgets/custom_text.dart';

void main() {
  group('CustomText', () {
    testWidgets('should render text correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: CustomText('Hello'))));
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('should apply h1 style', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: CustomText('H1', variant: TextVariant.h1))));
      final textWidget = tester.widget<Text>(find.text('H1'));
      expect(textWidget.style?.fontSize, 28);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('should apply custom color', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: CustomText('Color', color: Colors.red))));
      final textWidget = tester.widget<Text>(find.text('Color'));
      expect(textWidget.style?.color, Colors.red);
    });
    
    testWidgets('should apply all variants', (WidgetTester tester) async {
      for (var variant in TextVariant.values) {
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: CustomText(variant.name, variant: variant))));
        expect(find.text(variant.name), findsOneWidget);
      }
    });
  });
}
