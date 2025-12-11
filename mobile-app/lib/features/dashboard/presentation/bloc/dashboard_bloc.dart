import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class DashboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {}
class RefreshDashboard extends DashboardEvent {}

// States
abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardData data;
  DashboardLoaded(this.data);
  
  @override
  List<Object?> get props => [data];
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
  
  @override
  List<Object?> get props => [message];
}

// Data Model
class DashboardData extends Equatable {
  final int totalFields;
  final int activeTasks;
  final int completedTasks;
  final double avgNdvi;
  final double temperature;
  final int humidity;

  const DashboardData({
    this.totalFields = 0,
    this.activeTasks = 0,
    this.completedTasks = 0,
    this.avgNdvi = 0.0,
    this.temperature = 0.0,
    this.humidity = 0,
  });

  @override
  List<Object?> get props => [totalFields, activeTasks, completedTasks];
}

// BLoC
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboard(LoadDashboard event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock data
    emit(DashboardLoaded(const DashboardData(
      totalFields: 12,
      activeTasks: 8,
      completedTasks: 45,
      avgNdvi: 0.72,
      temperature: 28.5,
      humidity: 45,
    )));
  }

  Future<void> _onRefreshDashboard(RefreshDashboard event, Emitter<DashboardState> emit) async {
    add(LoadDashboard());
  }
}
