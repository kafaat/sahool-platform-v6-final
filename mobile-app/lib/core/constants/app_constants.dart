class AppConstants {
  AppConstants._();
  
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String tenantIdKey = 'tenant_id';
  static const String themeKey = 'theme_mode';
  
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  
  static const int minPasswordLength = 8;
  static const int defaultPageSize = 20;
  
  static const double defaultLatitude = 24.7136;
  static const double defaultLongitude = 46.6753;
}
