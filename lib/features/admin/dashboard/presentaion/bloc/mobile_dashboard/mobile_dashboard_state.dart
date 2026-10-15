part of 'mobile_dashboard_bloc.dart';

sealed class MobileDashboardState extends Equatable {
  const MobileDashboardState();

  @override
  List<Object> get props => [];
}

final class MobileDashboardInitial extends MobileDashboardState {}

final class MobileDashboardLoading extends MobileDashboardState {}

final class MobileDashboardLoaded extends MobileDashboardState {
  final MobileDashboardResponseModel dashboard;

  const MobileDashboardLoaded(this.dashboard);

  @override
  List<Object> get props => [dashboard];
}

final class MobileDashboardError extends MobileDashboardState {
  final String message;

  const MobileDashboardError(this.message);

  @override
  List<Object> get props => [message];
}
