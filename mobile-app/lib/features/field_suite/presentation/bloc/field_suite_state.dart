import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class FieldSuiteState extends Equatable {
  final String fieldId;
  final String fieldName;
  final bool loading;
  final List<LatLng> points;
  final List<LatLng> history;
  final bool freeDrawMode;
  final List<LatLng> freeDrawPoints;
  final bool showNdvi;
  final bool showZones;
  final bool isPivot;
  final LatLng? pivotCenter;
  final double? pivotRadiusMeters;
  final String? error;
  final String? infoMessage;
  final String? ndviTilesTemplate;

  const FieldSuiteState({
    required this.fieldId,
    required this.fieldName,
    required this.loading,
    required this.points,
    required this.history,
    required this.freeDrawMode,
    required this.freeDrawPoints,
    required this.showNdvi,
    required this.showZones,
    required this.isPivot,
    this.pivotCenter,
    this.pivotRadiusMeters,
    this.error,
    this.infoMessage,
    this.ndviTilesTemplate,
  });

  factory FieldSuiteState.initial(String fieldId, String fieldName) =>
      FieldSuiteState(
        fieldId: fieldId,
        fieldName: fieldName,
        loading: true,
        points: const [],
        history: const [],
        freeDrawMode: false,
        freeDrawPoints: const [],
        showNdvi: false,
        showZones: false,
        isPivot: false,
        pivotCenter: null,
        pivotRadiusMeters: null,
        error: null,
        infoMessage: null,
        ndviTilesTemplate: null,
      );

  FieldSuiteState copyWith({
    String? fieldId,
    String? fieldName,
    bool? loading,
    List<LatLng>? points,
    List<LatLng>? history,
    bool? freeDrawMode,
    List<LatLng>? freeDrawPoints,
    bool? showNdvi,
    bool? showZones,
    bool? isPivot,
    LatLng? pivotCenter,
    double? pivotRadiusMeters,
    String? error,
    String? infoMessage,
    String? ndviTilesTemplate,
  }) {
    return FieldSuiteState(
      fieldId: fieldId ?? this.fieldId,
      fieldName: fieldName ?? this.fieldName,
      loading: loading ?? this.loading,
      points: points ?? this.points,
      history: history ?? this.history,
      freeDrawMode: freeDrawMode ?? this.freeDrawMode,
      freeDrawPoints: freeDrawPoints ?? this.freeDrawPoints,
      showNdvi: showNdvi ?? this.showNdvi,
      showZones: showZones ?? this.showZones,
      isPivot: isPivot ?? this.isPivot,
      pivotCenter: pivotCenter ?? this.pivotCenter,
      pivotRadiusMeters: pivotRadiusMeters ?? this.pivotRadiusMeters,
      error: error,
      infoMessage: infoMessage,
      ndviTilesTemplate: ndviTilesTemplate ?? this.ndviTilesTemplate,
    );
  }

  @override
  List<Object?> get props => [
        fieldId,
        fieldName,
        loading,
        points,
        history,
        freeDrawMode,
        freeDrawPoints,
        showNdvi,
        showZones,
        isPivot,
        pivotCenter,
        pivotRadiusMeters,
        error,
        infoMessage,
        ndviTilesTemplate,
      ];
}
