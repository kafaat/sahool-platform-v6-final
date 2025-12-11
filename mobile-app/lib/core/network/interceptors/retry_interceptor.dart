import 'dart:async';
import 'package:dio/dio.dart';

/// Retry Interceptor - إعادة المحاولة التلقائية عند فشل الطلب
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;
  final List<int> retryableStatuses;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.retryableStatuses = const [408, 500, 502, 503, 504],
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final extra = err.requestOptions.extra;
    final retryCount = extra['retryCount'] ?? 0;

    // Check if we should retry
    if (_shouldRetry(err, retryCount)) {
      await Future.delayed(retryDelay * (retryCount + 1));

      try {
        err.requestOptions.extra['retryCount'] = retryCount + 1;
        final response = await Dio().fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        if (e is DioException) {
          return handler.next(e);
        }
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(DioException err, int retryCount) {
    if (retryCount >= maxRetries) return false;

    // Retry on timeout
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      return true;
    }

    // Retry on specific status codes
    final statusCode = err.response?.statusCode;
    if (statusCode != null && retryableStatuses.contains(statusCode)) {
      return true;
    }

    return false;
  }
}
