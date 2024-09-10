import '../environment.dart';

/// Provides a production environment configuration for the application.
extension ProductionEnvironment on Environment {
  /// Creates an instance of a production environment configuration.
  /// This typically includes a base URL pointing to a production server.
  static Environment production() {
    return Environment(url: '');
  }
}
