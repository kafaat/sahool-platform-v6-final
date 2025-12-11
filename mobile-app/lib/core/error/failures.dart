import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable implements Exception {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'لا يوجد اتصال بالإنترنت', super.code = 'NETWORK_ERROR'});
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({super.message = 'خطأ في الخادم', super.code = 'SERVER_ERROR', this.statusCode});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'غير مصرح', super.code = 'UNAUTHORIZED'});
}

class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;
  const ValidationFailure({super.message = 'خطأ في البيانات', super.code = 'VALIDATION_ERROR', this.fieldErrors});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'خطأ في التخزين', super.code = 'CACHE_ERROR'});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'غير موجود', super.code = 'NOT_FOUND'});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'خطأ غير معروف', super.code = 'UNKNOWN'});
}
