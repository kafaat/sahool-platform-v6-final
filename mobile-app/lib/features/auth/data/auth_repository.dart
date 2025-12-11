import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/network/api_endpoints.dart';

/// AuthRepository – جسر بين تطبيق SAHOOL mobile ومنصة platform-core (FastAPI).
///
/// يعتمد على OAuth2 password flow:
/// POST /api/v1/auth/token (application/x-www-form-urlencoded)
class AuthRepository {
  AuthRepository({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppConfig.platformCoreBaseUrl,
                connectTimeout: AppConfig.connectionTimeout,
                receiveTimeout: AppConfig.receiveTimeout,
                headers: const {
                  'Accept': 'application/json',
                },
              ),
            );

  final Dio _dio;

  /// تسجيل الدخول واسترجاع حزمة التوكن كما هي.
  ///
  /// Expected schema (Token):
  /// {
  ///   "access_token": "string",
  ///   "token_type": "bearer"
  /// }
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.authToken,
      data: {
        'username': username,
        'password': password,
        'grant_type': 'password',
        'scope': '',
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    return Map<String, dynamic>.from(response.data as Map);
  }

  /// قراءة المستخدم الحالي عبر /api/v1/users/me
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await _dio.get(ApiEndpoints.usersMe);
    return Map<String, dynamic>.from(response.data as Map);
  }
}