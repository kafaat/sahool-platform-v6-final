import 'package:equatable/equatable.dart';

abstract class AnalyticsOverviewEvent extends Equatable {
  const AnalyticsOverviewEvent();

  @override
  List<Object?> get props => [];
}

class LoadAnalyticsOverview extends AnalyticsOverviewEvent {
  final String? fieldId;

  const LoadAnalyticsOverview({this.fieldId});

  @override
  List<Object?> get props => [fieldId];
}
