part of 'daily_attendance_details_bloc.dart';

sealed class DailyAttendanceDetailsEvent extends Equatable {
  const DailyAttendanceDetailsEvent();

  @override
  List<Object> get props => [];
}

final class LoadDailyAttendanceDetailsEvent
    extends DailyAttendanceDetailsEvent {

  final String token;
  final DailyAttendanceDetailsRequestModel request;

  const LoadDailyAttendanceDetailsEvent({
    required this.token,
    required this.request,
  });

  @override
  List<Object> get props => [token, request];
}
