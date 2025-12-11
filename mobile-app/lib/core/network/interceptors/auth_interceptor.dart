import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../di/injection.dart';

import '../../constants/app_constants.dart';

/// AuthInterceptor
/// يضيف هيدر Authorization Bearer لكل طلب إذا كان التوكن موجوداً في التخزين الآمن.
/// كما يتعامل مع 401 بشكل بسيط عبر مسح التوكن.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(),
        _prefs = getIt<SharedPreferences>();

  final FlutterSecureStorage _storage;
  final SharedPreferences _prefs;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // إضافة معرّف المستأجر إن كان متوفراً
    final tenantId = _prefs.getInt(AppConstants.tenantIdKey);
    if (tenantId != null && tenantId > 0) {
      options.headers['X-Tenant-ID'] = tenantId.toString();
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode ?? 0;
    if (status == 401) {
      // جلسة منتهية – نحذف التوكنات فقط.
      await _storage.delete(key: AppConstants.accessTokenKey);
      await _storage.delete(key: AppConstants.refreshTokenKey);
    }
    handler.next(err);
  }
}