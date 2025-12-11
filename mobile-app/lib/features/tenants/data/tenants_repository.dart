import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';

/// TenantsRepository – wraps /api/v1/tenants APIs.
class TenantsRepository {
  final Dio _dio;

  TenantsRepository(this._dio);

  Future<Map<String, dynamic>> createTenant(Map<String, dynamic> body) async {
    final response = await _dio.post(ApiEndpoints.tenants, data: body);
    return Map<String, dynamic>.from(response.data as Map);
  }
}
