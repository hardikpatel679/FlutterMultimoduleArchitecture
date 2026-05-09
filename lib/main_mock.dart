import 'package:core/config/flavor_config.dart';
import 'main.dart' as app;

void main() {
  FlavorConfig.flavor = Flavor.mock;
  app.main();
}
