import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/field_boundary.dart';

class FieldSuiteLocalDataSource {
  final SharedPreferences prefs;

  FieldSuiteLocalDataSource(this.prefs);

  static String _keyForField(String fieldId) => 'field_suite_field_$fieldId';

  Future<void> cacheField(FieldBoundary boundary) async {
    final data = {
      'id': boundary.id,
      'name': boundary.name,
      'points': boundary.points
          .map((p) => {'lat': p.latitude, 'lng': p.longitude})
          .toList(),
      'isPivot': boundary.isPivot,
      'pivotCenter': boundary.pivotCenter == null
          ? null
          : {'lat': boundary.pivotCenter!.latitude, 'lng': boundary.pivotCenter!.longitude},
      'pivotRadiusMeters': boundary.pivotRadiusMeters,
    };
    await prefs.setString(_keyForField(boundary.id), jsonEncode(data));
  }

  Future<FieldBoundary?> getCachedField(String fieldId) async {
    final raw = prefs.getString(_keyForField(fieldId));
    if (raw == null) return null;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final pts = (data['points'] as List)
        .map<LatLng>((e) => LatLng(e['lat'] as double, e['lng'] as double))
        .toList();
    return FieldBoundary(
      id: data['id'].toString(),
      name: data['name']?.toString() ?? 'Field',
      points: pts,
      isPivot: data['isPivot'] as bool? ?? false,
      pivotCenter: data['pivotCenter'] == null
          ? null
          : LatLng(
              (data['pivotCenter']['lat'] as num).toDouble(),
              (data['pivotCenter']['lng'] as num).toDouble(),
            ),
      pivotRadiusMeters:
          (data['pivotRadiusMeters'] as num?)?.toDouble(),
    );
  }
}
