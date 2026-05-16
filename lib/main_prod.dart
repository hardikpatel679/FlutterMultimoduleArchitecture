import 'package:core/config/flavor_config.dart';
import 'main.dart' as app;

Future<void> main() async {
  FlavorConfig.flavor = Flavor.prod;
  await app.main();
}
