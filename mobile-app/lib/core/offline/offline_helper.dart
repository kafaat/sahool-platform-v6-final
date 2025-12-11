import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../di/injection.dart';

/// طبقة مساعدة بسيطة للتخزين المحلي (Offline)
class OfflineHelper {
  OfflineHelper._();

  // مفاتيح التخزين
  static const String _aiMessagesKey = 'offline_ai_messages_v1';
  static const String _ndviScenesKey = 'offline_ndvi_scenes_v1';
  static const String _fieldCreationsKey = 'offline_field_creations_v1';
  static const String _fieldHubSnapshotsKey = 'offline_field_hub_snapshots_v1';

  /// حفظ رسائل المساعد الذكي كـ JSON
  static Future<void> saveAiMessages(List<Map<String, dynamic>> messages) async {
    final prefs = getIt<SharedPreferences>();
    final encoded = messages.map((m) => jsonEncode(m)).toList();
    await prefs.setStringList(_aiMessagesKey, encoded);
  }

  /// استرجاع رسائل المساعد الذكي المخزنة محلياً
  static List<Map<String, dynamic>> loadAiMessages() {
    final prefs = getIt<SharedPreferences>();
    final encoded = prefs.getStringList(_aiMessagesKey) ?? <String>[];
    final List<Map<String, dynamic>> result = [];
    for (final item in encoded) {
      try {
        final decoded = jsonDecode(item) as Map<String, dynamic>;
        result.add(decoded);
      } catch (_) {}
    }
    return result;
  }

  /// حفظ مشاهد NDVI كـ JSON (للاستخدام في وضع Offline)
  static Future<void> saveNdviScenes(List<Map<String, dynamic>> scenes) async {
    final prefs = getIt<SharedPreferences>();
    final encoded = scenes.map((m) => jsonEncode(m)).toList();
    await prefs.setStringList(_ndviScenesKey, encoded);
  }

  /// استرجاع مشاهد NDVI المخزنة
  static List<Map<String, dynamic>> loadNdviScenes() {
    final prefs = getIt<SharedPreferences>();
    final encoded = prefs.getStringList(_ndviScenesKey) ?? <String>[];
    final List<Map<String, dynamic>> result = [];
    for (final item in encoded) {
      try {
        final decoded = jsonDecode(item) as Map<String, dynamic>;
        result.add(decoded);
      } catch (_) {}
    }
    return result;
  }

  /// حفظ طلب إنشاء حقل ليتم مزامنته لاحقاً عند توفر الاتصال
  static Future<void> enqueueFieldCreation(Map<String, dynamic> payload) async {
    final prefs = getIt<SharedPreferences>();
    final encodedList = prefs.getStringList(_fieldCreationsKey) ?? <String>[];
    encodedList.add(jsonEncode(payload));
    await prefs.setStringList(_fieldCreationsKey, encodedList);
  }

  /// استرجاع جميع طلبات إنشاء الحقول المخزنة مؤقتاً
  static List<Map<String, dynamic>> loadQueuedFieldCreations() {
    final prefs = getIt<SharedPreferences>();
    final encodedList = prefs.getStringList(_fieldCreationsKey) ?? <String>[];
    final List<Map<String, dynamic>> result = [];
    for (final item in encodedList) {
      try {
        final decoded = jsonDecode(item) as Map<String, dynamic>;
        result.add(decoded);
      } catch (_) {}
    }
    return result;
  }

  /// حذف جميع طلبات إنشاء الحقول المخزنة
  static Future<void> clearQueuedFieldCreations() async {
    final prefs = getIt<SharedPreferences>();
    await prefs.remove(_fieldCreationsKey);
  }

  /// حفظ لقطة متكاملة للوحة الحقل (FieldHub) حسب المعرّف
  ///
  /// يتم تخزين خريطة من fieldId -> snapshot JSON داخل prefs
  static Future<void> saveFieldHubSnapshot(
    String fieldId,
    Map<String, dynamic> snapshot,
  ) async {
    final prefs = getIt<SharedPreferences>();
    final raw = prefs.getString(_fieldHubSnapshotsKey);
    Map<String, dynamic> all = {};
    if (raw != null && raw.isNotEmpty) {
      try {
        all = jsonDecode(raw) as Map<String, dynamic>;
      } catch (_) {
        all = {};
      }
    }
    all[fieldId] = snapshot;
    await prefs.setString(_fieldHubSnapshotsKey, jsonEncode(all));
  }

  /// استرجاع لقطة الحقل المخزنة محلياً (إن وجدت)
  static Map<String, dynamic>? loadFieldHubSnapshot(String fieldId) {
    final prefs = getIt<SharedPreferences>();
    final raw = prefs.getString(_fieldHubSnapshotsKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final all = jsonDecode(raw) as Map<String, dynamic>;
      final data = all[fieldId];
      if (data is Map<String, dynamic>) {
        return data;
      }
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}