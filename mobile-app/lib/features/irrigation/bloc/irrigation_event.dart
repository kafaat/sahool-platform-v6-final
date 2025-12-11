import 'package:equatable/equatable.dart';

abstract class IrrigationEvent extends Equatable {
  const IrrigationEvent();

  @override
  List<Object?> get props => [];
}

class LoadIrrigation extends IrrigationEvent {
  final String fieldId;
  const LoadIrrigation(this.fieldId);

  @override
  List<Object?> get props => [fieldId];
}

class AddCycle extends IrrigationEvent {
  final String fieldId;
  final Map<String, dynamic> body;
  const AddCycle({required this.fieldId, required this.body});

  @override
  List<Object?> get props => [fieldId, body];
}

class DeleteCycle extends IrrigationEvent {
  final String fieldId;
  final String id;
  const DeleteCycle({required this.fieldId, required this.id});

  @override
  List<Object?> get props => [fieldId, id];
}
