import 'package:equatable/equatable.dart';

class LivestockState extends Equatable {
  final bool loading;
  final List<Map<String, dynamic>> items;
  final String? error;

  const LivestockState({
    required this.loading,
    required this.items,
    this.error,
  });

  factory LivestockState.initial() =>
      const LivestockState(loading: true, items: [], error: null);

  LivestockState copyWith({
    bool? loading,
    List<Map<String, dynamic>>? items,
    String? error,
  }) {
    return LivestockState(
      loading: loading ?? this.loading,
      items: items ?? this.items,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, items, error];
}
