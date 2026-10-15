part of 'teacher_dashboard_bloc.dart';

sealed class TeacherDashboardEvent extends Equatable {
  const TeacherDashboardEvent();

  @override
  List<Object> get props => [];
}

final class FetchTeacherDashboard extends TeacherDashboardEvent {
  const FetchTeacherDashboard();
}