part of 'teacher_dashboard_bloc.dart';

sealed class TeacherDashboardState extends Equatable {
  const TeacherDashboardState();

  @override
  List<Object> get props => [];
}

final class TeacherDashboardInitial extends TeacherDashboardState {}

final class TeacherDashboardLoading extends TeacherDashboardState {}

final class TeacherDashboardSuccess extends TeacherDashboardState {
  final TeacherDashboardModel dashboard;

  const TeacherDashboardSuccess({
    required this.dashboard,
  });

  @override
  List<Object> get props => [dashboard];
}

final class TeacherDashboardFailure extends TeacherDashboardState {
  final String message;

  const TeacherDashboardFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}