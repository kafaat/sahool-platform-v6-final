import 'package:equatable/equatable.dart';

class NdviSceneEntity extends Equatable {
  final String id;
  final DateTime date;
  final double avgNdvi;
  final double cloudCoverage;

  const NdviSceneEntity({
    required this.id,
    required this.date,
    required this.avgNdvi,
    required this.cloudCoverage,
  });

  @override
  List<Object?> get props => [id, date, avgNdvi, cloudCoverage];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'avgNdvi': avgNdvi,
      'cloudCoverage': cloudCoverage,
    };
  }

  factory NdviSceneEntity.fromJson(Map<String, dynamic> json) {
    return NdviSceneEntity(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      avgNdvi: (json['avgNdvi'] as num).toDouble(),
      cloudCoverage: (json['cloudCoverage'] as num).toDouble(),
    );
  }
}
