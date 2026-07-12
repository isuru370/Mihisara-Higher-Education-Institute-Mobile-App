import 'student_info.dart';
import 'attendance_info.dart';
import 'payment_info.dart';

class StudentData {
  final int enrollmentId;
  final StudentInfo student;
  final AttendanceInfo attendance;
  final PaymentInfo payment;

  StudentData({
    required this.enrollmentId,
    required this.student,
    required this.attendance,
    required this.payment,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    return StudentData(
      enrollmentId: json['enrollment_id'] ?? 0,
      student: StudentInfo.fromJson(json['student'] ?? {}),
      attendance: AttendanceInfo.fromJson(json['attendance'] ?? {}),
      payment: PaymentInfo.fromJson(json['payment'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enrollment_id': enrollmentId,
      'student': student.toJson(),
      'attendance': attendance.toJson(),
      'payment': payment.toJson(),
    };
  }
}