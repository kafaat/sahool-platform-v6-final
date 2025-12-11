import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'sync_operation.dart';

class SyncQueue {
  static const String _storageKey = 'sync_queue';
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<void> add(SyncOperation operation) async {
    final prefs = await _prefs;
    final operations = await _getAll();
    operations.add(operation);
    await prefs.setString(_storageKey, jsonEncode(operations.map((e) => e.toJson()).toList()));
  }

  Future<List<SyncOperation>> getPending() async {
    final all = await _getAll();
    return all.where((op) => op.status == SyncOperationStatus.pending).toList();
  }

  Future<void> markCompleted(String id) async => _updateStatus(id, SyncOperationStatus.completed);

  Future<void> markFailed(String id, String error) async {
    final prefs = await _prefs;
    final operations = await _getAll();
    final index = operations.indexWhere((op) => op.id == id);
    if (index != -1) {
      final op = operations[index];
      operations[index] = op.copyWith(status: SyncOperationStatus.failed, retryCount: op.retryCount + 1, errorMessage: error);
      await prefs.setString(_storageKey, jsonEncode(operations.map((e) => e.toJson()).toList()));
    }
  }

  Future<int> count() async => (await getPending()).length;

  Future<void> clearCompleted() async {
    final prefs = await _prefs;
    final operations = await _getAll();
    final pending = operations.where((op) => op.status != SyncOperationStatus.completed).toList();
    await prefs.setString(_storageKey, jsonEncode(pending.map((e) => e.toJson()).toList()));
  }

  Future<List<SyncOperation>> _getAll() async {
    final prefs = await _prefs;
    final json = prefs.getString(_storageKey);
    if (json == null || json.isEmpty) return [];
    return (jsonDecode(json) as List).map((e) => SyncOperation.fromJson(e)).toList();
  }

  Future<void> _updateStatus(String id, SyncOperationStatus status) async {
    final prefs = await _prefs;
    final operations = await _getAll();
    final index = operations.indexWhere((op) => op.id == id);
    if (index != -1) {
      operations[index] = operations[index].copyWith(status: status, syncedAt: status == SyncOperationStatus.completed ? DateTime.now() : null);
      await prefs.setString(_storageKey, jsonEncode(operations.map((e) => e.toJson()).toList()));
    }
  }
}
