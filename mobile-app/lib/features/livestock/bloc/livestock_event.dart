import 'package:equatable/equatable.dart';

abstract class LivestockEvent extends Equatable {
  const LivestockEvent();

  @override
  List<Object?> get props => [];
}

class LoadLivestock extends LivestockEvent {
  final String fieldId;
  const LoadLivestock(this.fieldId);

  @override
  List<Object?> get props => [fieldId];
}
