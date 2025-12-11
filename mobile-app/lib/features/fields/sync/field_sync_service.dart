import 'package:dio/dio.dart';
import '../../../core/di/injection.dart';
import '../../../core/offline/offline_helper.dart';
import '../data/field_repository.dart';
import '../../../domain/entities/field_entity.dart';

/// خدمة لمزامنة الحقول المنشأة في وضع Offline مع الخادم
class FieldSyncService {
  FieldSyncService({
    Dio? dio,
    FieldRepository? repository,
  })  : _dio = dio ?? getIt<Dio>(),
        _repository = repository ?? FieldRepository(dio: dio ?? getIt<Dio>());

  final Dio _dio;
  final FieldRepository _repository;

  /// يعيد عدد الحقول التي تمت مزامنتها بنجاح
  Future<int> syncOfflineCreations() async {
    final queued = OfflineHelper.loadQueuedFieldCreations();
    if (queued.isEmpty) {
      return 0;
    }

    int successCount = 0;
    final List<Map<String, dynamic>> remaining = [];

    for (final payload in queued) {
      try {
        final String name = (payload['name'] ?? '') as String;
        final String? crop = payload['crop'] as String?;
        final double? areaHa =
            (payload['areaHa'] as num?)?.toDouble();
        final Map<String, dynamic>? boundary =
            payload['boundary'] as Map<String, dynamic>?;

        final FieldEntity field = await _repository.createField(
          name: name,
          cropType: crop,
          areaHa: areaHa,
          boundaryGeoJson: boundary,
        );
        successCount += 1;
        // يمكن لاحقاً إرسال إشعار محلي بنجاح المزامنة لكل حقل
      } catch (_) {
        // إذا فشل هذا الطلب نعيده إلى قائمة الانتظار
        remaining.add(payload);
      }
    }

    // تحديث التخزين بناءً على ما تبقى
    if (remaining.isEmpty) {
      await OfflineHelper.clearQueuedFieldCreations();
    } else {
      // نعيد كتابة القائمة بما تبقى فقط
      // (لا يوجد API مباشر، لذا نحذف المفتاح ثم نضيف من جديد)
      await OfflineHelper.clearQueuedFieldCreations();
      for (final item in remaining) {
        await OfflineHelper.enqueueFieldCreation(item);
      }
    }

    return successCount;
  }
}