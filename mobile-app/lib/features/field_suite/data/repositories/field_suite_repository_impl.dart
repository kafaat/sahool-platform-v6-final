import 'package:latlong2/latlong.dart';

import '../../domain/entities/field_boundary.dart';
import '../../domain/repositories/field_suite_repository.dart';
import '../datasources/field_suite_local_datasource.dart';
import '../datasources/field_suite_remote_datasource.dart';

class FieldSuiteRepositoryImpl implements FieldSuiteRepository {
  final FieldSuiteRemoteDataSource remote;
  final FieldSuiteLocalDataSource local;

  FieldSuiteRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<void> cacheFieldLocally(FieldBoundary boundary) {
    return local.cacheField(boundary);
  }

  @override
  Future<void> deleteField(String fieldId) {
    return remote.deleteField(fieldId);
  }

  @override
  Future<FieldBoundary> getField(String fieldId) async {
    final cached = await local.getCachedField(fieldId);
    if (cached != null) return cached;
    final remoteField = await remote.getField(fieldId);
    await local.cacheField(remoteField);
    return remoteField;
  }

  @override
  Future<FieldBoundary?> getCachedField(String fieldId) {
    return local.getCachedField(fieldId);
  }

  @override
  Future<List<FieldBoundary>> listFields() {
    return remote.listFields();
  }

  @override
  Future<void> saveField(FieldBoundary boundary) async {
    await remote.saveField(boundary);
    await local.cacheField(boundary);
  }

  @override
  Future<Map<String, dynamic>> getNdviZones(String fieldId) {
    return remote.getNdviZones(fieldId);
  }

  @override
  Future<String> getNdviTilesTemplate(String fieldId) {
    return Future.value(remote.getNdviTilesTemplate(fieldId));
  }
}
