part of 'scan_attendance_bloc.dart';

sealed class ScanAttendanceState extends Equatable {
  const ScanAttendanceState();

  @override
  List<Object?> get props => [];
}

class ScanAttendanceInitial extends ScanAttendanceState {}

class ScanAttendanceLoading extends ScanAttendanceState {}

class ScanAttendanceSuccess extends ScanAttendanceState {
  final ScanAttendanceResponseModel response;

  const ScanAttendanceSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class ScanAttendanceFailure extends ScanAttendanceState {
  final String message;

  const ScanAttendanceFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
