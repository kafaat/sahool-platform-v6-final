import 'package:latlong2/latlong.dart';
import '../entities/field_boundary.dart';

abstract class FieldSuiteRepository {
  Future<FieldBoundary> getField(String fieldId);
  Future<List<FieldBoundary>> listFields();
  Future<void> saveField(FieldBoundary boundary);
  Future<void> deleteField(String fieldId);

  Future<Map<String, dynamic>> getNdviZones(String fieldId);
  Future<String> getNdviTilesTemplate(String fieldId);

  Future<void> cacheFieldLocally(FieldBoundary boundary);
  Future<FieldBoundary?> getCachedField(String fieldId);
}
