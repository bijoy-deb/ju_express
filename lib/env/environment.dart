import 'package:ju_express/env/dev/dev_env.dart';
import 'package:ju_express/env/prod/prod_env.dart';

// Defines the environment configuration for the application.
// This includes the base URL for API endpoints.
class Environment {
  final String url;

  // Constructs an Environment object with the given URL.
  Environment({required this.url});

  // Creates an environment configuration for the development environment.
  factory Environment.development() {
    return DevelopmentEnvironment.development();
  }

  // Creates an environment configuration for the production environment.
  factory Environment.production() {
    return ProductionEnvironment.production();
  }
}
