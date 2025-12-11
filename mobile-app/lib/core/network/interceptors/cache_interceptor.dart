import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cache Interceptor - يخزن الردود مؤقتاً لتحسين الأداء
class CacheInterceptor extends Interceptor {
  final Duration cacheDuration;
  final SharedPreferences _prefs;

  CacheInterceptor({
    required SharedPreferences prefs,
    this.cacheDuration = const Duration(minutes: 5),
  }) : _prefs = prefs;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Only cache GET requests
    if (options.method != 'GET') {
      return handler.next(options);
    }

    // Check if we should skip cache
    if (options.extra['skipCache'] == true) {
      return handler.next(options);
    }

    final cacheKey = _generateCacheKey(options);
    final cachedData = _prefs.getString(cacheKey);
    final cacheTime = _prefs.getInt('${cacheKey}_time');

    if (cachedData != null && cacheTime != null) {
      final cacheDate = DateTime.fromMillisecondsSinceEpoch(cacheTime);
      if (DateTime.now().difference(cacheDate) < cacheDuration) {
        // Return cached response
        return handler.resolve(
          Response(
            requestOptions: options,
            data: jsonDecode(cachedData),
            statusCode: 200,
            extra: {'fromCache': true},
          ),
        );
      }
    }

    return handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    // Only cache GET successful responses
    if (response.requestOptions.method == 'GET' &&
        response.statusCode == 200) {
      final cacheKey = _generateCacheKey(response.requestOptions);
      await _prefs.setString(cacheKey, jsonEncode(response.data));
      await _prefs.setInt('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
    }

    return handler.next(response);
  }

  String _generateCacheKey(RequestOptions options) {
    return 'cache_${options.uri.toString().hashCode}';
  }
}
