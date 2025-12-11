import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

class AppLogger {
  static bool _initialized = false;

  static void init(Environment environment) {
    if (_initialized) return;
    _initialized = true;
  }

  static void v(String message, {String? tag}) => _log('V', message, tag);
  static void d(String message, {String? tag}) => _log('D', message, tag);
  static void i(String message, {String? tag}) => _log('I', message, tag);
  static void w(String message, {String? tag}) => _log('W', message, tag);
  
  static void e(String message, {String? tag, dynamic error, StackTrace? stackTrace}) {
    _log('E', message, tag);
    if (error != null && kDebugMode) debugPrint('Error: $error');
    if (stackTrace != null && kDebugMode) debugPrint('Stack: $stackTrace');
  }

  static void _log(String level, String message, String? tag) {
    if (!kDebugMode) return;
    final logTag = tag ?? 'SAHOOL';
    developer.log('[$level] $message', name: logTag);
  }
}
