import 'read_attendance_model.dart';
import 'read_last_payment_model.dart';

class ReadStudentClassPaymentModel {
  final int enrollmentId;
  final int studentClassId;
  final int classCategoryId;
  final String className;
  final String categoryName;
  final String teacherInitials;
  final String grade;
  final String subject;
  final bool isFreeCard;
  final int finalFee;
  final ReadLastPaymentModel? lastPayment;
  final ReadAttendanceModel? attendance;

  ReadStudentClassPaymentModel({
    required this.enrollmentId,
    required this.studentClassId,
    required this.classCategoryId,
    required this.className,
    required this.categoryName,
    required this.teacherInitials,
    required this.grade,
    required this.subject,
    required this.isFreeCard,
    required this.finalFee,
    required this.lastPayment,
    required this.attendance,
  });

  factory ReadStudentClassPaymentModel.fromJson(Map<String, dynamic> json) {
    return ReadStudentClassPaymentModel(
      enrollmentId: json['enrollment_id'] ?? 0,
      studentClassId: json['student_class_id'] ?? 0,
      classCategoryId: json['class_category_id'] ?? 0,
      className: json['class_name'] ?? '',
      categoryName: json['category_name'] ?? '',
      teacherInitials: json['teacher_initials'] ?? '',
      grade: json['grade']?.toString() ?? '',
      subject: json['subject'] ?? '',
      isFreeCard: json['is_free_card'] ?? false,
      finalFee: _toInt(json['final_fee']),
      lastPayment: json['last_payment'] != null
          ? ReadLastPaymentModel.fromJson(
              json['last_payment'] as Map<String, dynamic>,
            )
          : null,
      attendance: json['attendance'] != null
          ? ReadAttendanceModel.fromJson(
              json['attendance'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}