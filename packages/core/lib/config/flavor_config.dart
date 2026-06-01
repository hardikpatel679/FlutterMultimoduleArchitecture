enum Flavor { dev, prod, mock, ust }

class FlavorConfig {
  static Flavor flavor = Flavor.dev;

  static bool get isMock => flavor == Flavor.mock;
  static bool get isDev => flavor == Flavor.dev;
  static bool get isProd => flavor == Flavor.prod;
  static bool get isUst => flavor == Flavor.ust;
}
