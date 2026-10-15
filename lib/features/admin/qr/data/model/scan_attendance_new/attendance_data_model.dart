import 'attendance_result_model.dart';
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
  final AttendanceResultModel attendanceResult;

  AttendanceDataModel({
    required this.student,
    required this.schedule,
    required this.enrollment,
    this.lastPayment,
    required this.attendance,
    required this.tute,
    required this.attendanceResult,
  });

  factory AttendanceDataModel.fromJson(Map<String, dynamic> json) {
    return AttendanceDataModel(
      student: StudentModel.fromJson(json['student'] as Map<String, dynamic>),

      schedule: ScheduleModel.fromJson(
        json['schedule'] as Map<String, dynamic>,
      ),

      enrollment: EnrollmentModel.fromJson(
        json['enrollment'] as Map<String, dynamic>,
      ),

      lastPayment: json['last_payment'] is Map<String, dynamic>
          ? LastPaymentModel.fromJson(
              json['last_payment'] as Map<String, dynamic>,
            )
          : null,

      attendance: AttendanceSummaryModel.fromJson(
        json['attendance'] as Map<String, dynamic>,
      ),

      tute: TuteModel.fromJson(json['tute'] as Map<String, dynamic>),
      attendanceResult: AttendanceResultModel.fromJson(
        json['attendance'] as Map<String, dynamic>,
      ),
    );
  }
}
