import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/field_entity.dart';
import '../../data/field_repository.dart';
import '../../../../core/offline/offline_helper.dart';

abstract class CreateFieldEvent {}

class CreateFieldSubmitted extends CreateFieldEvent {
  final String name;
  final String? crop;
  final double? areaHa;
  final Map<String, dynamic>? boundary;

  CreateFieldSubmitted({
    required this.name,
    this.crop,
    this.areaHa,
    this.boundary,
  });
}

abstract class CreateFieldState {}

class CreateFieldInitial extends CreateFieldState {}

class CreateFieldInProgress extends CreateFieldState {}

class CreateFieldSuccess extends CreateFieldState {
  final FieldEntity field;

  CreateFieldSuccess(this.field);
}

class CreateFieldFailure extends CreateFieldState {
  final String message;

  CreateFieldFailure(this.message);
}

class CreateFieldBloc extends Bloc<CreateFieldEvent, CreateFieldState> {
  final FieldRepository repository;

  CreateFieldBloc({required this.repository}) : super(CreateFieldInitial()) {
    on<CreateFieldSubmitted>(_onSubmit);
  }

  Future<void> _onSubmit(
    CreateFieldSubmitted event,
    Emitter<CreateFieldState> emit,
  ) async {
    emit(CreateFieldInProgress());
    try {
      final field = await repository.createField(
        name: event.name,
        cropType: event.crop,
        areaHa: event.areaHa,
        boundaryGeoJson: event.boundary,
      );
      emit(CreateFieldSuccess(field));
    } catch (e) {
      // في حالة الفشل (غالباً بسبب الاتصال) نخزن الطلب للمزامنة لاحقاً
      await OfflineHelper.enqueueFieldCreation({
        'name': event.name,
        'crop': event.crop,
        'areaHa': event.areaHa,
        'boundary': event.boundary,
      });
      emit(CreateFieldFailure(
        'تعذر الاتصال بالخادم، تم حفظ الحقل للمزامنة لاحقاً.\n${e.toString()}',
      ));
    }
  }
}