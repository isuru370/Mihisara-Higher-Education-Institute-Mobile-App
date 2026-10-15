part of 'scan_attendance_bloc.dart';

sealed class ScanAttendanceEvent extends Equatable {
  const ScanAttendanceEvent();

  @override
  List<Object?> get props => [];
}

class ScanAttendanceRequested extends ScanAttendanceEvent {
  final String code;
  final String markMethod;

  const ScanAttendanceRequested({
    required this.code,
    this.markMethod = 'qr_mobile',
  });

  @override
  List<Object?> get props => [
        code,
        markMethod,
      ];
}

class ScanAttendanceReset extends ScanAttendanceEvent {
  const ScanAttendanceReset();
}