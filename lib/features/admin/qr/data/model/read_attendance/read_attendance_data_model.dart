import 'attendance_model.dart';
import 'enrollment_model.dart';
import 'last_payment_model.dart';
import 'student_model.dart';
import 'tute_model.dart';

class ReadAttendanceDataModel {
  final StudentModel student;
  final EnrollmentModel enrollment;
  final AttendanceModel attendance;

  final LastPaymentModel? lastPayment;

  final TuteModel? tute;

  ReadAttendanceDataModel({
    required this.student,
    required this.enrollment,
    required this.attendance,
    this.lastPayment,
    this.tute,
  });

  factory ReadAttendanceDataModel.fromJson(Map<String, dynamic>? json) {
    return ReadAttendanceDataModel(
      student: StudentModel.fromJson(
        json?['student'] as Map<String, dynamic>? ?? {},
      ),

      enrollment: EnrollmentModel.fromJson(
        json?['enrollment'] as Map<String, dynamic>? ?? {},
      ),

      attendance: AttendanceModel.fromJson(
        json?['attendance'] as Map<String, dynamic>? ?? {},
      ),

      lastPayment: json?['last_payment'] != null
          ? LastPaymentModel.fromJson(
              json?['last_payment'] as Map<String, dynamic>,
            )
          : null,

      tute: json?['tute'] != null
          ? TuteModel.fromJson(json?['tute'] as Map<String, dynamic>)
          : null,
    );
  }
}
