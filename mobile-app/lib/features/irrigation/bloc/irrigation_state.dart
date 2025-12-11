import 'package:equatable/equatable.dart';

class IrrigationState extends Equatable {
  final bool loading;
  final List<Map<String, dynamic>> items;
  final String? error;

  const IrrigationState({
    required this.loading,
    required this.items,
    this.error,
  });

  factory IrrigationState.initial() =>
      const IrrigationState(loading: true, items: [], error: null);

  IrrigationState copyWith({
    bool? loading,
    List<Map<String, dynamic>>? items,
    String? error,
  }) {
    return IrrigationState(
      loading: loading ?? this.loading,
      items: items ?? this.items,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, items, error];
}
