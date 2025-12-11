import 'package:dio/dio.dart';

/// IrrigationRepository – manages irrigation cycles for fields.
///
/// NOTE: Endpoint paths are indicative and should be aligned with backend.
/// Example assumed endpoints:
///   GET    /api/v1/irrigation?field_id=...
///   POST   /api/v1/irrigation
///   DELETE /api/v1/irrigation/{id}
class IrrigationRepository {
  final Dio _dio;

  IrrigationRepository(this._dio);

  Future<List<Map<String, dynamic>>> fetch(String fieldId) async {
    final res = await _dio.get(
      '/api/v1/irrigation',
      queryParameters: {'field_id': fieldId},
    );
    final list = res.data as List;
    return list.cast<Map<String, dynamic>>();
  }

  Future<void> create(String fieldId, Map<String, dynamic> body) async {
    await _dio.post(
      '/api/v1/irrigation',
      data: {
        'field_id': fieldId,
        ...body,
      },
    );
  }

  Future<void> remove(String id) async {
    await _dio.delete('/api/v1/irrigation/$id');
  }
}
