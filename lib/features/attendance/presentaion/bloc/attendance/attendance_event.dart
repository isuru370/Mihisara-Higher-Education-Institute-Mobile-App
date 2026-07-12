part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

class MarkAttendanceRequested extends AttendanceEvent {
  final AttendanceRequestModel request;

  const MarkAttendanceRequested({required this.request});

  @override
  List<Object?> get props => [request];
}

class AttendanceHistoryRequested extends AttendanceEvent {
  final AttendanceHistoryRequestModel request;

  const AttendanceHistoryRequested({required this.request});

  @override
  List<Object?> get props => [request];
}

class AttendanceReportRequested extends AttendanceEvent {
  final int scheduleId;

  const AttendanceReportRequested({required this.scheduleId});

  @override
  List<Object?> get props => [scheduleId];
}
