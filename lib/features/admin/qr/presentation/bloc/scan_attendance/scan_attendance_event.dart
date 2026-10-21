part of 'scan_attendance_bloc.dart';

sealed class ScanAttendanceEvent extends Equatable {
  const ScanAttendanceEvent();

  @override
  List<Object?> get props => [];
}

class ScanAttendanceRequested extends ScanAttendanceEvent {
  final String code;
  final String markMethod;

  /// Set when the staff member picked a class from the selection list.
  final int? classScheduleId;

  const ScanAttendanceRequested({
    required this.code,
    this.markMethod = 'qr_mobile',
    this.classScheduleId,
  });

  @override
  List<Object?> get props => [
        code,
        markMethod,
        classScheduleId,
      ];
}

class ScanAttendanceReset extends ScanAttendanceEvent {
  const ScanAttendanceReset();
}