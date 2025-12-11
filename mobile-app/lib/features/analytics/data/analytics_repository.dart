import 'package:dio/dio.dart';

/// AnalyticsRepository – unified wrapper around analytics-style endpoints
/// (NDVI trends, irrigation usage, livestock analytics, overview dashboards).
class AnalyticsRepository {
  final Dio _dio;

  AnalyticsRepository(this._dio);

  /// High-level farm overview: aggregated stats for dashboard.
  Future<Map<String, dynamic>> fetchOverview() async {
    final res = await _dio.get('/api/v1/analytics/overview');
    return Map<String, dynamic>.from(res.data as Map);
  }

  /// NDVI trend over time for a given field.
  Future<List<Map<String, dynamic>>> fetchNdviTrend(String fieldId) async {
    final res = await _dio.get(
      '/api/v1/analytics/ndvi',
      queryParameters: {'field_id': fieldId},
    );
    final data = res.data as List;
    return data.cast<Map<String, dynamic>>();
  }

  /// Irrigation usage analytics per field.
  Future<List<Map<String, dynamic>>> fetchIrrigationUsage(String fieldId) async {
    final res = await _dio.get(
      '/api/v1/analytics/irrigation',
      queryParameters: {'field_id': fieldId},
    );
    final data = res.data as List;
    return data.cast<Map<String, dynamic>>();
  }

  /// Livestock analytics per field.
  Future<List<Map<String, dynamic>>> fetchLivestockAnalytics(String fieldId) async {
    final res = await _dio.get(
      '/api/v1/analytics/livestock',
      queryParameters: {'field_id': fieldId},
    );
    final data = res.data as List;
    return data.cast<Map<String, dynamic>>();
  }
}
