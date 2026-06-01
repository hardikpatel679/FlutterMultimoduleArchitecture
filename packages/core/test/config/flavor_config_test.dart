import 'package:flutter_test/flutter_test.dart';
import 'package:core/config/flavor_config.dart';

void main() {
  group('FlavorConfig', () {
    test('should correctly identify dev flavor', () {
      FlavorConfig.flavor = Flavor.dev;
      expect(FlavorConfig.isDev, true);
      expect(FlavorConfig.isProd, false);
      expect(FlavorConfig.isMock, false);
    });

    test('should correctly identify prod flavor', () {
      FlavorConfig.flavor = Flavor.prod;
      expect(FlavorConfig.isDev, false);
      expect(FlavorConfig.isProd, true);
      expect(FlavorConfig.isMock, false);
    });

    test('should correctly identify mock flavor', () {
      FlavorConfig.flavor = Flavor.mock;
      expect(FlavorConfig.isDev, false);
      expect(FlavorConfig.isProd, false);
      expect(FlavorConfig.isMock, true);
    });
  });
}
