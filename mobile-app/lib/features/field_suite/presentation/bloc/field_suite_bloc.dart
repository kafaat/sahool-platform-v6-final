import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/field_boundary.dart';
import '../../domain/repositories/field_suite_repository.dart';
import 'field_suite_event.dart';
import 'field_suite_state.dart';

class FieldSuiteBloc extends Bloc<FieldSuiteEvent, FieldSuiteState> {
  final FieldSuiteRepository repo;

  FieldSuiteBloc({
    required this.repo,
    required String fieldId,
    required String fieldName,
  }) : super(FieldSuiteState.initial(fieldId, fieldName)) {
    on<FieldSuiteInit>(_onInit);
    on<FieldSuiteAddPoint>(_onAddPoint);
    on<FieldSuiteUndo>(_onUndo);
    on<FieldSuiteRedo>(_onRedo);
    on<FieldSuiteToggleFreeDraw>(_onToggleFreeDraw);
    on<FieldSuiteFreeDrawAdd>(_onFreeDrawAdd);
    on<FieldSuiteToggleNdvi>(_onToggleNdvi);
    on<FieldSuiteToggleZones>(_onToggleZones);
    on<FieldSuiteDetectPivot>(_onDetectPivot);
    on<FieldSuiteSave>(_onSave);
    on<FieldSuiteDelete>(_onDelete);
  }

  Future<void> _onInit(
      FieldSuiteInit event, Emitter<FieldSuiteState> emit) async {
    emit(state.copyWith(loading: true, error: null, infoMessage: null));
    try {
      final field = await repo.getField(event.fieldId);
      final tiles = await repo.getNdviTilesTemplate(event.fieldId);
      emit(state.copyWith(
        loading: false,
        points: field.points,
        ndviTilesTemplate: tiles,
      ));
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        error: 'فشل تحميل بيانات الحقل',
      ));
    }
  }

  void _onAddPoint(
      FieldSuiteAddPoint event, Emitter<FieldSuiteState> emit) {
    final snappedGrid = _snapToGrid(event.point);
    final snapped = _snapToNearestEdge(snappedGrid, state.points);
    final pts = List<LatLng>.from(state.points)..add(snapped);
    emit(state.copyWith(points: pts));
    if (pts.length == 2) {
      add(const FieldSuiteDetectPivot());
    }
  }

  void _onUndo(FieldSuiteUndo event, Emitter<FieldSuiteState> emit) {
    if (state.points.isEmpty) return;
    final pts = List<LatLng>.from(state.points);
    final last = pts.removeLast();
    final hist = List<LatLng>.from(state.history)..add(last);
    emit(state.copyWith(points: pts, history: hist));
  }

  void _onRedo(FieldSuiteRedo event, Emitter<FieldSuiteState> emit) {
    if (state.history.isEmpty) return;
    final hist = List<LatLng>.from(state.history);
    final last = hist.removeLast();
    final pts = List<LatLng>.from(state.points)..add(last);
    emit(state.copyWith(points: pts, history: hist));
  }

  void _onToggleFreeDraw(
      FieldSuiteToggleFreeDraw event, Emitter<FieldSuiteState> emit) {
    emit(state.copyWith(freeDrawMode: !state.freeDrawMode));
  }

  void _onFreeDrawAdd(
      FieldSuiteFreeDrawAdd event, Emitter<FieldSuiteState> emit) {
    final pts = List<LatLng>.from(state.freeDrawPoints)..add(event.point);
    emit(state.copyWith(freeDrawPoints: pts));
  }

  void _onToggleNdvi(
      FieldSuiteToggleNdvi event, Emitter<FieldSuiteState> emit) {
    emit(state.copyWith(showNdvi: !state.showNdvi));
  }

  void _onToggleZones(
      FieldSuiteToggleZones event, Emitter<FieldSuiteState> emit) {
    emit(state.copyWith(showZones: !state.showZones));
  }

  void _onDetectPivot(
      FieldSuiteDetectPivot event, Emitter<FieldSuiteState> emit) {
    if (state.points.length < 2) return;
    final center = state.points[0];
    final edge = state.points[1];
    final radius = _distanceMeters(center, edge);
    emit(state.copyWith(
      isPivot: true,
      pivotCenter: center,
      pivotRadiusMeters: radius,
    ));
  }

  Future<void> _onSave(
      FieldSuiteSave event, Emitter<FieldSuiteState> emit) async {
    emit(state.copyWith(loading: true, error: null, infoMessage: null));
    try {
      final boundary = FieldBoundary(
        id: state.fieldId,
        name: state.fieldName,
        points: state.points,
        isPivot: state.isPivot,
        pivotCenter: state.pivotCenter,
        pivotRadiusMeters: state.pivotRadiusMeters,
      );
      await repo.saveField(boundary);
      emit(state.copyWith(
        loading: false,
        infoMessage: 'تم حفظ الحقل بنجاح',
      ));
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        error: 'فشل حفظ بيانات الحقل',
      ));
    }
  }

  Future<void> _onDelete(
      FieldSuiteDelete event, Emitter<FieldSuiteState> emit) async {
    emit(state.copyWith(loading: true, error: null, infoMessage: null));
    try {
      await repo.deleteField(state.fieldId);
      emit(state.copyWith(
        loading: false,
        infoMessage: 'تم حذف الحقل',
      ));
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        error: 'فشل حذف الحقل',
      ));
    }
  }

  LatLng _snapToGrid(LatLng p) {
    const grid = 0.00005; // ~5m
    final lat = (p.latitude / grid).round() * grid;
    final lng = (p.longitude / grid).round() * grid;
    return LatLng(lat, lng);
  }

  LatLng _snapToNearestEdge(LatLng p, List<LatLng> pts) {
    if (pts.length < 2) return p;
    LatLng best = p;
    double minDist = double.infinity;
    for (int i = 1; i < pts.length; i++) {
      final a = pts[i - 1];
      final b = pts[i];
      final proj = _projectPointToSegment(a, b, p);
      final d = _distanceMeters(proj, p);
      if (d < minDist && d < 3.0) {
        minDist = d;
        best = proj;
      }
    }
    return best;
  }

  LatLng _projectPointToSegment(LatLng a, LatLng b, LatLng p) {
    final ax = a.longitude;
    final ay = a.latitude;
    final bx = b.longitude;
    final by = b.latitude;
    final px = p.longitude;
    final py = p.latitude;

    final abx = bx - ax;
    final aby = by - ay;
    final apx = px - ax;
    final apy = py - ay;

    final ab2 = abx * abx + aby * aby;
    if (ab2 == 0) return a;

    double t = (apx * abx + apy * aby) / ab2;
    t = t.clamp(0.0, 1.0);
    return LatLng(ay + aby * t, ax + abx * t);
  }

  double _distanceMeters(LatLng a, LatLng b) {
    const R = 6371000.0;
    final dLat = _degToRad(b.latitude - a.latitude);
    final dLon = _degToRad(b.longitude - a.longitude);
    final lat1 = _degToRad(a.latitude);
    final lat2 = _degToRad(b.latitude);

    final h = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
    return R * c;
  }

  double _degToRad(double d) => d * math.pi / 180.0;
}
