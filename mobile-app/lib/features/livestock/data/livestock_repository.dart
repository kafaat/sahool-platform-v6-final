import 'package:dio/dio.dart';

/// LivestockRepository – manages livestock records per field.
///
/// Assumed endpoints:
///   GET /api/v1/livestock?field_id=...
class LivestockRepository {
  final Dio _dio;

  LivestockRepository(this._dio);

  Future<List<Map<String, dynamic>>> fetch(String fieldId) async {
    final res = await _dio.get(
      '/api/v1/livestock',
      queryParameters: {'field_id': fieldId},
    );
    final list = res.data as List;
    return list.cast<Map<String, dynamic>>();
  }
}
