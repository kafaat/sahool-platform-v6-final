import 'package:equatable/equatable.dart';

class AnalyticsOverviewState extends Equatable {
  final bool loading;
  final Map<String, dynamic>? data;
  final String? error;

  const AnalyticsOverviewState({
    required this.loading,
    this.data,
    this.error,
  });

  factory AnalyticsOverviewState.initial() =>
      const AnalyticsOverviewState(loading: true, data: null, error: null);

  AnalyticsOverviewState copyWith({
    bool? loading,
    Map<String, dynamic>? data,
    String? error,
  }) {
    return AnalyticsOverviewState(
      loading: loading ?? this.loading,
      data: data ?? this.data,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, data ?? {}, error ?? ''];
}
