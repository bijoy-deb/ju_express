import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/api_client/api_client.dart';

@module
abstract class ServiceModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @injectable
  ApiClient get apiClient => ApiClient();

  @Singleton()
  InternetConnectionChecker get connectionChecker =>
      InternetConnectionChecker();

  // @preResolve
  // Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();
}
