import '../environment.dart';

/// Provides a development environment configuration for the application.
extension DevelopmentEnvironment on Environment {
  /// Creates an instance of a development environment configuration.
  /// This typically includes a base URL pointing to a local or development server.
  static Environment development() {
    return Environment(url: 'https://demo.cwticketingsystem.com/');
  }
}
