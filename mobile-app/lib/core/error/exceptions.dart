class AppException implements Exception {
  final String message;
  final String? code;

  const AppException({required this.message, this.code});

  @override
  String toString() => 'AppException($code): $message';
}

class NetworkException extends AppException {
  const NetworkException({super.message = 'Network error', super.code = 'NETWORK'});
}

class ServerException extends AppException {
  final int? statusCode;
  const ServerException({super.message = 'Server error', super.code = 'SERVER', this.statusCode});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({super.message = 'Unauthorized', super.code = 'UNAUTHORIZED'});
}

class CacheException extends AppException {
  const CacheException({super.message = 'Cache error', super.code = 'CACHE'});
}

class ValidationException extends AppException {
  final Map<String, dynamic>? errors;
  const ValidationException({super.message = 'Validation error', super.code = 'VALIDATION', this.errors});
}
