import 'dart:convert';
import 'package:dio/dio.dart';
import '../../logging/app_logger.dart';
import '../../config/app_config.dart';

/// Logging Interceptor - تسجيل كل الطلبات والردود للتصحيح
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!AppConfig.isDebug) return handler.next(options);

    AppLogger.d(
      '┌──────────────────────────────────────────────────────────',
      tag: 'HTTP',
    );
    AppLogger.d('│ ${options.method} ${options.uri}', tag: 'HTTP');
    AppLogger.d('│ Headers: ${_prettyJson(options.headers)}', tag: 'HTTP');
    if (options.data != null) {
      AppLogger.d('│ Body: ${_prettyJson(options.data)}', tag: 'HTTP');
    }
    AppLogger.d(
      '└──────────────────────────────────────────────────────────',
      tag: 'HTTP',
    );

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!AppConfig.isDebug) return handler.next(response);

    AppLogger.d(
      '┌──────────────────────────────────────────────────────────',
      tag: 'HTTP',
    );
    AppLogger.d(
      '│ ${response.statusCode} ${response.requestOptions.uri}',
      tag: 'HTTP',
    );
    AppLogger.d('│ Response: ${_truncate(_prettyJson(response.data))}', tag: 'HTTP');
    AppLogger.d(
      '└──────────────────────────────────────────────────────────',
      tag: 'HTTP',
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e(
      '┌──────────────────────────────────────────────────────────',
      tag: 'HTTP',
    );
    AppLogger.e('│ ERROR: ${err.type}', tag: 'HTTP');
    AppLogger.e('│ ${err.requestOptions.method} ${err.requestOptions.uri}', tag: 'HTTP');
    AppLogger.e('│ Message: ${err.message}', tag: 'HTTP');
    if (err.response != null) {
      AppLogger.e('│ Status: ${err.response?.statusCode}', tag: 'HTTP');
      AppLogger.e('│ Response: ${err.response?.data}', tag: 'HTTP');
    }
    AppLogger.e(
      '└──────────────────────────────────────────────────────────',
      tag: 'HTTP',
    );

    handler.next(err);
  }

  String _prettyJson(dynamic json) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } catch (_) {
      return json.toString();
    }
  }

  String _truncate(String text, {int maxLength = 500}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}... [truncated]';
  }
}
