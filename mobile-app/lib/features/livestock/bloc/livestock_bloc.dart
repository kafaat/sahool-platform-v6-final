import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/livestock_repository.dart';
import 'livestock_event.dart';
import 'livestock_state.dart';

class LivestockBloc extends Bloc<LivestockEvent, LivestockState> {
  final LivestockRepository repo;

  LivestockBloc(this.repo) : super(LivestockState.initial()) {
    on<LoadLivestock>(_onLoad);
  }

  Future<void> _onLoad(
    LoadLivestock event,
    Emitter<LivestockState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final data = await repo.fetch(event.fieldId);
      emit(state.copyWith(loading: false, items: data));
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: 'فشل تحميل بيانات المواشي',
        ),
      );
    }
  }
}
