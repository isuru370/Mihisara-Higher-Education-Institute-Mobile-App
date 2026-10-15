part of 'mobile_dashboard_bloc.dart';

sealed class MobileDashboardEvent extends Equatable {
  const MobileDashboardEvent();

  @override
  List<Object> get props => [];
}

class GetMobileDashboardEvent extends MobileDashboardEvent {}
