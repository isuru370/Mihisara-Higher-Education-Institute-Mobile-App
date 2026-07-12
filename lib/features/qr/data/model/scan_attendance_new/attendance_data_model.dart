import 'student_model.dart';
import 'schedule_model.dart';
import 'enrollment_model.dart';
import 'last_payment_model.dart';
import 'attendance_summary_model.dart';
import 'tute_model.dart';

class AttendanceDataModel {
  final StudentModel student;
  final ScheduleModel schedule;
  final EnrollmentModel enrollment;
  final LastPaymentModel? lastPayment;
  final AttendanceSummaryModel attendance;
  final TuteModel tute;

  AttendanceDataModel({
    required this.student,
    required this.schedule,
    required this.enrollment,
    this.lastPayment,
    required this.attendance,
    required this.tute,
  });

  factory AttendanceDataModel.fromJson(Map<String, dynamic> json) {
    return AttendanceDataModel(
      student: StudentModel.fromJson(json['student']),
      schedule: ScheduleModel.fromJson(json['schedule']),
      enrollment: EnrollmentModel.fromJson(json['enrollment']),
      lastPayment: json['last_payment'] != null
          ? LastPaymentModel.fromJson(json['last_payment'])
          : null,
      attendance: AttendanceSummaryModel.fromJson(json['attendance']),
      tute: TuteModel.fromJson(json['tute']),
    );
  }
}