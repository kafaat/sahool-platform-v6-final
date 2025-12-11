import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/field_entity.dart';
import '../../data/field_repository.dart';

abstract class FieldListEvent {}

class FieldListRequested extends FieldListEvent {}

class FieldListRefreshed extends FieldListEvent {}

abstract class FieldListState {}

class FieldListInitial extends FieldListState {}

class FieldListLoading extends FieldListState {}

class FieldListLoaded extends FieldListState {
  final List<FieldEntity> fields;

  FieldListLoaded(this.fields);
}

class FieldListFailure extends FieldListState {
  final String message;

  FieldListFailure(this.message);
}

class FieldListBloc extends Bloc<FieldListEvent, FieldListState> {
  final FieldRepository repository;

  FieldListBloc({required this.repository}) : super(FieldListInitial()) {
    on<FieldListRequested>(_onLoad);
    on<FieldListRefreshed>(_onLoad);
  }

  Future<void> _onLoad(FieldListEvent event, Emitter<FieldListState> emit) async {
    emit(FieldListLoading());
    try {
      final fields = await repository.getFields();
      emit(FieldListLoaded(fields));
    } catch (e) {
      emit(FieldListFailure(e.toString()));
    }
  }
}