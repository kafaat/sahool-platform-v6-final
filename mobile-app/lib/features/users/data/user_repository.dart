import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';

/// UserRepository – wraps /api/v1/users & /api/v1/users/me.
class UserRepository {
  final Dio _dio;

  UserRepository(this._dio);

  Future<Map<String, dynamic>> createUser(Map<String, dynamic> body) async {
    final response = await _dio.post(ApiEndpoints.users, data: body);
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await _dio.get(ApiEndpoints.usersMe);
    return Map<String, dynamic>.from(response.data as Map);
  }
}
