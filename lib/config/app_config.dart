import 'package:ju_express/config/app_config_type.dart';
import 'package:ju_express/env/environment.dart';

// Centralized configuration for the application.
// Holds environment settings and provides access to key configuration values.
class AppConfig with AppConfigType {
  // Singleton instance of AppConfig.
  static final AppConfig shared = AppConfig._instance();

  // Factory constructor to initialize the shared instance with the given environment.
  factory AppConfig({required Environment env}) {
    shared.env = env;
    return shared;
  }

  // Private constructor to enforce singleton pattern.
  AppConfig._instance();

// The environment configuration for the app
  Environment? env;

  // Returns the base URL for API endpoints based on the current environment.
  @override
  String get baseURL => env?.url ?? '';
}
