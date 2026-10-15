part of 'daily_attendance_details_bloc.dart';

sealed class DailyAttendanceDetailsState extends Equatable {
  const DailyAttendanceDetailsState();

  @override
  List<Object> get props => [];
}

final class DailyAttendanceDetailsInitial extends DailyAttendanceDetailsState {}

final class DailyAttendanceDetailsLoading extends DailyAttendanceDetailsState {}

final class DailyAttendanceDetailsLoaded extends DailyAttendanceDetailsState {
  final DailyAttendanceDetailsResponseModel response;

  const DailyAttendanceDetailsLoaded(this.response);

  @override
  List<Object> get props => [response];
}

final class DailyAttendanceDetailsError extends DailyAttendanceDetailsState {
  final String message;

  const DailyAttendanceDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
