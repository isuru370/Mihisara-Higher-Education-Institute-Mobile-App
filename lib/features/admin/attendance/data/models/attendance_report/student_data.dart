import 'student_info.dart';
import 'attendance_info.dart';
import 'payment_info.dart';

class StudentData {
  final int? enrollmentId;
  final bool enrollmentStatus;
  final StudentInfo student;
  final AttendanceInfo attendance;
  final PaymentInfo payment;

  StudentData({
    required this.enrollmentId,
    required this.enrollmentStatus,
    required this.student,
    required this.attendance,
    required this.payment,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    return StudentData(
      enrollmentId: json['enrollment_id'],
      enrollmentStatus: json['enrollment_status'] ?? false,
      student: StudentInfo.fromJson(json['student'] ?? {}),
      attendance: AttendanceInfo.fromJson(json['attendance'] ?? {}),
      payment: PaymentInfo.fromJson(json['payment'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enrollment_id': enrollmentId,
      'enrollment_status': enrollmentStatus,
      'student': student.toJson(),
      'attendance': attendance.toJson(),
      'payment': payment.toJson(),
    };
  }
}