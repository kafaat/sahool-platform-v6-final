import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

abstract class FieldSuiteEvent extends Equatable {
  const FieldSuiteEvent();

  @override
  List<Object?> get props => [];
}

class FieldSuiteInit extends FieldSuiteEvent {
  final String fieldId;
  const FieldSuiteInit(this.fieldId);

  @override
  List<Object?> get props => [fieldId];
}

class FieldSuiteAddPoint extends FieldSuiteEvent {
  final LatLng point;
  const FieldSuiteAddPoint(this.point);

  @override
  List<Object?> get props => [point];
}

class FieldSuiteUndo extends FieldSuiteEvent {}

class FieldSuiteRedo extends FieldSuiteEvent {}

class FieldSuiteToggleFreeDraw extends FieldSuiteEvent {}

class FieldSuiteFreeDrawAdd extends FieldSuiteEvent {
  final LatLng point;
  const FieldSuiteFreeDrawAdd(this.point);

  @override
  List<Object?> get props => [point];
}

class FieldSuiteToggleNdvi extends FieldSuiteEvent {}

class FieldSuiteToggleZones extends FieldSuiteEvent {}

class FieldSuiteDetectPivot extends FieldSuiteEvent {}

class FieldSuiteSave extends FieldSuiteEvent {}

class FieldSuiteDelete extends FieldSuiteEvent {}
