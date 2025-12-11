class ApiEndpoints {
  ApiEndpoints._();

  // ===== Auth (gateway) =====
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String profile = '/auth/profile';
  static const String updateProfile = '/auth/profile';

  // ===== Platform-core (direct) =====
  // NOTE: هذه المسارات تُستخدم مع AppConfig.platformCoreBaseUrl
  // مثل: http://localhost:9002/api/v1 + authToken
  static const String authToken = '/auth/token';
  static const String tenants = '/tenants';
  static const String users = '/users';
  static const String usersMe = '/users/me';

  // ===== Fields / Agronomy (gateway) =====
  static const String fields = '/fields';
  static const String fieldById = '/fields/{id}';
  static const String fieldNdvi = '/fields/{id}/ndvi';
  static const String fieldSoil = '/fields/{id}/soil';
  static const String fieldWeather = '/fields/{id}/weather';
  static const String fieldTasks = '/fields/{id}/tasks';
  static const String fieldIrrigation = '/fields/{id}/irrigation';
  static const String fieldLivestock = '/fields/{id}/livestock';

  // ===== NDVI =====
  static const String ndviScenes = '/ndvi/scenes';
  static const String ndviTimeSeries = '/ndvi/time-series';
  static const String ndviAnomalies = '/ndvi/anomalies';

  // ===== Weather =====
  static const String weatherCurrent = '/weather/current';
  static const String weatherForecast = '/weather/forecast';
  static const String weatherAlerts = '/weather/alerts';

  // ===== Dashboard =====
  static const String dashboardStats = '/dashboard/stats';
  static const String dashboardAlerts = '/dashboard/alerts';

  // ===== AI =====
  static const String aiChat = '/ai/chat';
  static const String aiRecommendations = '/ai/recommendations';

  // ===== Notifications =====
  static const String notifications = '/notifications';
}