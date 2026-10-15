part of 'read_attendance_bloc.dart';

sealed class ReadAttendanceEvent extends Equatable {
  const ReadAttendanceEvent();

  @override
  List<Object?> get props => [];
}

final class ReadAttendanceRequested extends ReadAttendanceEvent {
  final String qrCode;
  final int studentClassId;
  final int classCategoryFeeId;

  const ReadAttendanceRequested({
    required this.qrCode,
    required this.studentClassId,
    required this.classCategoryFeeId,
  });

  @override
  List<Object?> get props => [qrCode, studentClassId, classCategoryFeeId];
}