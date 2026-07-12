part of 'attendance_bloc.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

// Mark Attendance States
class AttendanceLoading extends AttendanceState {}

class AttendanceSuccess extends AttendanceState {
  final String message;
  final AttendanceResponseModel response;

  const AttendanceSuccess({required this.message, required this.response});

  @override
  List<Object?> get props => [message, response];
}

class AttendanceError extends AttendanceState {
  final String message;

  const AttendanceError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Attendance History States
class AttendanceHistoryLoading extends AttendanceState {}

class AttendanceHistoryLoaded extends AttendanceState {
  final AttendanceHistoryResponseModel response;

  const AttendanceHistoryLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class AttendanceHistoryError extends AttendanceState {
  final String message;

  const AttendanceHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Attendance Report States
class AttendanceReportLoading extends AttendanceState {}

class AttendanceReportLoaded extends AttendanceState {
  final AttendanceReportResponseModel response;

  const AttendanceReportLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class AttendanceReportError extends AttendanceState {
  final String message;

  const AttendanceReportError({required this.message});

  @override
  List<Object?> get props => [message];
}
