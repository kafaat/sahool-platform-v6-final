import 'package:equatable/equatable.dart';

class NdviData extends Equatable {
  final String id;
  final String fieldId;
  final double value;
  final DateTime capturedAt;
  final String? source;
  final List<NdviZone>? zones;

  const NdviData({
    required this.id,
    required this.fieldId,
    required this.value,
    required this.capturedAt,
    this.source,
    this.zones,
  });

  String get status {
    if (value >= 0.8) return 'excellent';
    if (value >= 0.6) return 'good';
    if (value >= 0.4) return 'moderate';
    if (value >= 0.2) return 'poor';
    return 'critical';
  }

  String get statusArabic {
    switch (status) {
      case 'excellent': return 'ممتاز';
      case 'good': return 'جيد';
      case 'moderate': return 'متوسط';
      case 'poor': return 'ضعيف';
      default: return 'حرج';
    }
  }

  @override
  List<Object?> get props => [id, fieldId, value, capturedAt];
}

class NdviZone extends Equatable {
  final String id;
  final double minLat;
  final double maxLat;
  final double minLng;
  final double maxLng;
  final double value;

  const NdviZone({
    required this.id,
    required this.minLat,
    required this.maxLat,
    required this.minLng,
    required this.maxLng,
    required this.value,
  });

  @override
  List<Object?> get props => [id, value];
}

class NdviHistory extends Equatable {
  final String fieldId;
  final List<NdviData> history;
  final double averageValue;
  final double trend;

  const NdviHistory({
    required this.fieldId,
    required this.history,
    required this.averageValue,
    required this.trend,
  });

  bool get isImproving => trend > 0;
  bool get isDeclining => trend < 0;

  @override
  List<Object?> get props => [fieldId, history.length];
}
