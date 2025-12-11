import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/field_boundary.dart';

class FieldSuiteRemoteDataSource {
  final Dio dio;

  FieldSuiteRemoteDataSource(this.dio);

  Future<FieldBoundary> getField(String fieldId) async {
    final res = await dio.get('/fields/$fieldId');
    final data = res.data as Map<String, dynamic>;
    final boundary = (data['boundary']?['coordinates']?[0] as List?)
            ?.map<LatLng>((c) => LatLng(c[1] as double, c[0] as double))
            .toList() ??
        <LatLng>[];
    return FieldBoundary(
      id: data['id'].toString(),
      name: data['name']?.toString() ?? 'Field',
      points: boundary,
    );
  }

  Future<List<FieldBoundary>> listFields() async {
    final res = await dio.get('/fields');
    final list = (res.data['results'] as List? ?? []);
    return list.map<FieldBoundary>((e) {
      final boundary = (e['boundary']?['coordinates']?[0] as List?)
              ?.map<LatLng>((c) => LatLng(c[1] as double, c[0] as double))
              .toList() ??
          <LatLng>[];
      return FieldBoundary(
        id: e['id'].toString(),
        name: e['name']?.toString() ?? 'Field',
        points: boundary,
      );
    }).toList();
  }

  Future<void> saveField(FieldBoundary boundary) async {
    final geojson = boundary.toGeoJson();
    await dio.post('/fields', data: {
      'name': boundary.name,
      'boundary': geojson,
    });
  }

  Future<void> deleteField(String fieldId) async {
    await dio.delete('/fields/$fieldId');
  }

  Future<Map<String, dynamic>> getNdviZones(String fieldId) async {
    final res = await dio.get('/fields/$fieldId/ndvi/zones');
    return res.data as Map<String, dynamic>;
  }

  String getNdviTilesTemplate(String fieldId) {
    // This can be combined with baseUrl in Dio
    return '/fields/$fieldId/ndvi/tiles/{z}/{x}/{y}.png';
  }
}
