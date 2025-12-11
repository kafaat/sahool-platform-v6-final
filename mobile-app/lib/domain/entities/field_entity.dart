import 'package:equatable/equatable.dart';

class FieldEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double area;
  final String areaUnit;
  final String cropType;
  final String status;
  final double? latitude;
  final double? longitude;
  final List<LatLng>? boundaries;
  final double? ndviValue;
  final double? soilMoisture;
  final String? healthStatus;
  final DateTime? plantingDate;
  final DateTime? expectedHarvestDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FieldEntity({
    required this.id,
    required this.name,
    this.description,
    required this.area,
    this.areaUnit = 'هكتار',
    required this.cropType,
    this.status = 'active',
    this.latitude,
    this.longitude,
    this.boundaries,
    this.ndviValue,
    this.soilMoisture,
    this.healthStatus,
    this.plantingDate,
    this.expectedHarvestDate,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id];

  String get areaFormatted => '${area.toStringAsFixed(1)} $areaUnit';
  
  String get statusArabic {
    switch (status) {
      case 'active': return 'نشط';
      case 'planting': return 'زراعة';
      case 'growing': return 'نمو';
      case 'harvesting': return 'حصاد';
      case 'resting': return 'راحة';
      default: return status;
    }
  }

  String get cropTypeArabic {
    switch (cropType.toLowerCase()) {
      case 'wheat': return 'قمح';
      case 'barley': return 'شعير';
      case 'corn': return 'ذرة';
      case 'rice': return 'أرز';
      case 'dates': return 'نخيل';
      case 'vegetables': return 'خضروات';
      case 'fruits': return 'فواكه';
      case 'alfalfa': return 'برسيم';
      default: return cropType;
    }
  }
}

class LatLng extends Equatable {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}
