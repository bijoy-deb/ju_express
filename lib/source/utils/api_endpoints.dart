import '../../config/app_config.dart';

class APIEndPoints {
  static String webApi() => "${AppConfig.shared.baseURL}control/web_api/v5/";
}
