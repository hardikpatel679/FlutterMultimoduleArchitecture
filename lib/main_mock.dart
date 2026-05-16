import 'package:core/config/flavor_config.dart';
import 'main.dart' as app;

Future<void> main() async {
  FlavorConfig.flavor = Flavor.mock;
  await app.main();
}
