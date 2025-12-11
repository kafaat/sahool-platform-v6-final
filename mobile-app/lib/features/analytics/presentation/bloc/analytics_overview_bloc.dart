import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/analytics_repository.dart';
import 'analytics_overview_event.dart';
import 'analytics_overview_state.dart';

class AnalyticsOverviewBloc
    extends Bloc<AnalyticsOverviewEvent, AnalyticsOverviewState> {
  final AnalyticsRepository _repo;

  AnalyticsOverviewBloc(this._repo)
      : super(AnalyticsOverviewState.initial()) {
    on<LoadAnalyticsOverview>(_onLoad);
  }

  Future<void> _onLoad(
    LoadAnalyticsOverview event,
    Emitter<AnalyticsOverviewState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final data = await _repo.fetchOverview();
      emit(state.copyWith(loading: false, data: data));
    } catch (e) {
      emit(
        state.copyWith(
          loading: false,
          error: 'فشل في تحميل بيانات التحليلات',
        ),
      );
    }
  }
}
