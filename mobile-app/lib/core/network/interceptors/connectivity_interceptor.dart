import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../error/exceptions.dart';

/// Connectivity Interceptor - يتحقق من الاتصال قبل كل طلب
class ConnectivityInterceptor extends Interceptor {
  final Connectivity _connectivity;

  ConnectivityInterceptor({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final result = await _connectivity.checkConnectivity();
    
    if (result == ConnectivityResult.none) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: const NetworkException(
            message: 'لا يوجد اتصال بالإنترنت',
            code: 'NO_INTERNET',
          ),
          type: DioExceptionType.connectionError,
        ),
      );
    }

    return handler.next(options);
  }
}
