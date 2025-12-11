import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../domain/entities/field_entity.dart';

/// مستودع الحقول - يتكامل مع Smart Ag Gateway / المنصة الأساسية
class FieldRepository {
  FieldRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<List<FieldEntity>> getFields() async {
    final response = await _dio.get(ApiEndpoints.fields);
    final data = response.data;

    List<dynamic> items;
    if (data is List) {
      items = data;
    } else if (data is Map && data['items'] is List) {
      items = data['items'] as List<dynamic>;
    } else {
      items = const [];
    }

    return items
        .whereType<Map<String, dynamic>>()
        .map(_mapField)
        .toList();
  }

  Future<FieldEntity> createField({
    required String name,
    String? cropType,
    double? areaHa,
    Map<String, dynamic>? boundaryGeoJson,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      if (cropType != null && cropType.isNotEmpty) 'crop_type': cropType,
      if (areaHa != null) 'area': areaHa,
      if (boundaryGeoJson != null) 'boundary': boundaryGeoJson,
    };

    final response = await _dio.post(ApiEndpoints.fields, data: body);
    final data = response.data as Map<String, dynamic>;
    return _mapField(data);
  }

  FieldEntity _mapField(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final name = (json['name'] ?? 'حقل بدون اسم') as String;
    final desc = json['description'] as String?;
    final area = (json['area'] as num?)?.toDouble() ?? 0.0;
    final unit = (json['area_unit'] ?? 'هكتار') as String;
    final crop = (json['crop_type'] ?? json['crop'] ?? 'غير محدد') as String;
    final status = (json['status'] ?? 'active') as String;

    final ndviRaw = json['ndvi'] ?? json['latest_ndvi'] ?? json['ndvi_value'];
    final ndvi = (ndviRaw is num) ? ndviRaw.toDouble() : null;
    final soilMoisture = (json['soil_moisture'] as num?)?.toDouble();
    final health = json['health_status'] as String?;

    DateTime? _parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      if (v is String) {
        return DateTime.tryParse(v);
      }
      return null;
    }

    return FieldEntity(
      id: id,
      name: name,
      description: desc,
      area: area,
      areaUnit: unit,
      cropType: crop,
      status: status,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      boundaries: null, // يمكن ربطها لاحقاً بـ FieldSuite
      ndviValue: ndvi,
      soilMoisture: soilMoisture,
      healthStatus: health,
      plantingDate: _parseDate(json['planting_date']),
      expectedHarvestDate: _parseDate(json['expected_harvest_date']),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  

  /// جلب تفاصيل حقل واحد من الخادم
  Future<FieldEntity> getFieldById(String fieldId) async {
    final path = ApiEndpoints.fieldById.replaceFirst('{id}', fieldId);
    final response = await _dio.get(path);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return _mapField(data);
    }
    if (data is Map) {
      return _mapField(Map<String, dynamic>.from(data));
    }
    throw Exception('Unexpected field payload for id=$fieldId');
  }

  /// جلب ملخص NDVI للحقل
  Future<Map<String, dynamic>> getFieldNdviSnapshot(String fieldId) async {
    final path = ApiEndpoints.fieldNdvi.replaceFirst('{id}', fieldId);
    final response = await _dio.get(path);
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    if (response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }
    return <String, dynamic>{};
  }

  /// جلب Snapshot الطقس للحقل
  Future<Map<String, dynamic>> getFieldWeatherSnapshot(String fieldId) async {
    final path = ApiEndpoints.fieldWeather.replaceFirst('{id}', fieldId);
    final response = await _dio.get(path);
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    if (response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }
    return <String, dynamic>{};
  }

  /// جلب Snapshot التربة للحقل
  Future<Map<String, dynamic>> getFieldSoilSnapshot(String fieldId) async {
    final path = ApiEndpoints.fieldSoil.replaceFirst('{id}', fieldId);
    final response = await _dio.get(path);
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    if (response.data is Map) {
      return Map<String, dynamic>.from(response.data as Map);
    }
    return <String, dynamic>{};
  }

  /// جلب عدد المهام المفتوحة للحقل
  Future<int> getFieldOpenTasksCount(String fieldId) async {
    final path = ApiEndpoints.fieldTasks.replaceFirst('{id}', fieldId);
    final response = await _dio.get(path);
    final data = response.data;
    if (data is Map && data['open_count'] is num) {
      return (data['open_count'] as num).toInt();
    }
    if (data is List) {
      // كخيار افتراضي، نعتبر طول القائمة هو عدد المهام
      return data.length;
    }
    return 0;
  }

}
