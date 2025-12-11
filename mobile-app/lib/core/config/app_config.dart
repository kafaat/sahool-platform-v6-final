import 'package:flutter/foundation.dart';

enum Environment { development, staging, production }

class AppConfig {
  static late Environment _environment;
  static Environment get environment => _environment;

  static void initialize(Environment env) => _environment = env;

  static bool get isDevelopment => _environment == Environment.development;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isProduction => _environment == Environment.production;
  static bool get isDebug => kDebugMode;

  static const String appName = 'SAHOOL';

  // يمكن لاحقاً قراءة نسخة التطبيق من build.yaml أو من Native
  static const String version = '12.4.0';
  static const String buildNumber = '1';
  static String get fullVersion => '$version+$buildNumber';

  /// قاعدة الـ API العامة (Smart Ag Gateway)
  static String get apiBaseUrl {
    switch (_environment) {
      case Environment.development:
        return 'http://localhost:3000/api/v1';
      case Environment.staging:
        return 'https://staging-api.sahool.sa/v1';
      case Environment.production:
        return 'https://api.sahool.sa/v1';
    }
  }

  /// قاعدة منصة platform-core المباشرة (FastAPI)
  ///
  /// في التطوير: نتصل مباشرة على :9002 كما أرسلت الـ OpenAPI
  static String get platformCoreBaseUrl {
    switch (_environment) {
      case Environment.development:
        return 'http://localhost:9002/api/v1';
      case Environment.staging:
        return 'https://platform-core.staging.sahool.sa/api/v1';
      case Environment.production:
        return 'https://platform-core.sahool.sa/api/v1';
    }
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  static const int pageSize = 20;
}