enum Flavor { dev, prod, mock }

class FlavorConfig {
  static Flavor flavor = Flavor.dev;

  static bool get isMock => flavor == Flavor.mock;
  static bool get isDev => flavor == Flavor.dev;
  static bool get isProd => flavor == Flavor.prod;
}
