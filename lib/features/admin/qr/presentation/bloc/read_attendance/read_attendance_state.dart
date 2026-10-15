part of 'read_attendance_bloc.dart';

sealed class ReadAttendanceState extends Equatable {
  const ReadAttendanceState();

  @override
  List<Object?> get props => [];
}

final class ReadAttendanceInitial extends ReadAttendanceState {}

final class ReadAttendanceLoading extends ReadAttendanceState {}

final class ReadAttendanceLoaded extends ReadAttendanceState {
  final ReadAttendanceDataModel data;

  const ReadAttendanceLoaded({
    required this.data,
  });

  @override
  List<Object?> get props => [data];
}

final class ReadAttendanceError extends ReadAttendanceState {
  final String message;

  const ReadAttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}