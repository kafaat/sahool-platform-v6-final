import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/offline/offline_helper.dart';
import '../../../../domain/entities/ndvi_scene_entity.dart';

/// Events
abstract class NdviEvent extends Equatable {
  const NdviEvent();
  @override
  List<Object?> get props => [];
}

class NdviLoadRequested extends NdviEvent {
  const NdviLoadRequested();
}

class NdviDateSelected extends NdviEvent {
  final NdviSceneEntity scene;
  const NdviDateSelected(this.scene);

  @override
  List<Object?> get props => [scene];
}

/// State
class NdviState extends Equatable {
  final List<NdviSceneEntity> scenes;
  final NdviSceneEntity? selected;
  final bool isLoading;
  final String? error;

  const NdviState({
    required this.scenes,
    this.selected,
    this.isLoading = false,
    this.error,
  });

  NdviState copyWith({
    List<NdviSceneEntity>? scenes,
    NdviSceneEntity? selected,
    bool? isLoading,
    String? error,
  }) {
    return NdviState(
      scenes: scenes ?? this.scenes,
      selected: selected ?? this.selected,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [scenes, selected ?? '', isLoading, error ?? ''];
}

/// Bloc
class NdviBloc extends Bloc<NdviEvent, NdviState> {
  NdviBloc() : super(const NdviState(scenes: [])) {
    on<NdviLoadRequested>(_onLoad);
    on<NdviDateSelected>(_onSelect);
  }

  Future<void> _onLoad(
    NdviLoadRequested event,
    Emitter<NdviState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final cached = OfflineHelper.loadNdviScenes();
      List<NdviSceneEntity> scenes;
      if (cached.isNotEmpty) {
        scenes = cached.map(NdviSceneEntity.fromJson).toList();
      } else {
        scenes = _generateFakeScenes();
        await OfflineHelper.saveNdviScenes(
          scenes.map((e) => e.toJson()).toList(),
        );
      }
      scenes.sort((a, b) => b.date.compareTo(a.date));
      emit(
        NdviState(
          scenes: scenes,
          selected: scenes.isNotEmpty ? scenes.first : null,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'فشل في تحميل بيانات NDVI',
        ),
      );
    }
  }

  Future<void> _onSelect(
    NdviDateSelected event,
    Emitter<NdviState> emit,
  ) async {
    emit(state.copyWith(selected: event.scene));
  }

  List<NdviSceneEntity> _generateFakeScenes() {
    final now = DateTime.now();
    return List.generate(6, (i) {
      final date = now.subtract(Duration(days: i * 7));
      return NdviSceneEntity(
        id: 'fake-${date.toIso8601String()}',
        date: date,
        avgNdvi: 0.55 + (0.05 * (i % 3)),
        cloudCoverage: 10 + (5 * i),
      );
    });
  }
}
