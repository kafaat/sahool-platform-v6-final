import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/irrigation_repository.dart';
import 'irrigation_event.dart';
import 'irrigation_state.dart';

class IrrigationBloc extends Bloc<IrrigationEvent, IrrigationState> {
  final IrrigationRepository repo;

  IrrigationBloc(this.repo) : super(IrrigationState.initial()) {
    on<LoadIrrigation>(_onLoad);
    on<AddCycle>(_onAdd);
    on<DeleteCycle>(_onDelete);
  }

  Future<void> _onLoad(LoadIrrigation e, Emitter<IrrigationState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final data = await repo.fetch(e.fieldId);
      emit(state.copyWith(loading: false, items: data));
    } catch (err) {
      emit(state.copyWith(
        loading: false,
        error: 'فشل تحميل بيانات الري',
      ));
    }
  }

  Future<void> _onAdd(AddCycle e, Emitter<IrrigationState> emit) async {
    await repo.create(e.fieldId, e.body);
    add(LoadIrrigation(e.fieldId));
  }

  Future<void> _onDelete(DeleteCycle e, Emitter<IrrigationState> emit) async {
    await repo.remove(e.id);
    add(LoadIrrigation(e.fieldId));
  }
}
