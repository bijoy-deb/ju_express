import 'package:ju_express/main.dart' as app;
import '../config/app_config.dart';
import 'env/environment.dart';

Future<void> main() async {
  AppConfig(env: Environment.development());
  await app.main();
}
