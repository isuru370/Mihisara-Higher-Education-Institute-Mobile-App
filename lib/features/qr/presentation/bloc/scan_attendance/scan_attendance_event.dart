part of 'scan_attendance_bloc.dart';

sealed class ScanAttendanceEvent extends Equatable {
  const ScanAttendanceEvent();

  @override
  List<Object?> get props => [];
}

class ScanAttendanceRequested extends ScanAttendanceEvent {
  final String qrCode;

  const ScanAttendanceRequested({
    required this.qrCode,
  });

  @override
  List<Object?> get props => [qrCode];
}

class ScanAttendanceReset extends ScanAttendanceEvent {
  const ScanAttendanceReset();
}