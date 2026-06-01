import 'package:flutter_test/flutter_test.dart';
import 'package:core/utils/string_extensions.dart';

void main() {
  group('StringExtensions', () {
    test('format should replace placeholders correctly', () {
      const template = 'Hello {name}, welcome to {place}!';
      final values = {'name': 'Alice', 'place': 'Wonderland'};
      
      final result = template.format(values);
      
      expect(result, 'Hello Alice, welcome to Wonderland!');
    });

    test('format should return same string if no placeholders match', () {
      const template = 'Hello world';
      final values = {'name': 'Alice'};
      
      final result = template.format(values);
      
      expect(result, 'Hello world');
    });

    test('format should handle empty map', () {
      const template = 'Hello {name}';
      final result = template.format({});
      
      expect(result, 'Hello {name}');
    });
  });
}
