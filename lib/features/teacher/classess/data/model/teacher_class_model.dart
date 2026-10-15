import 'teacher_class_subject_model.dart';
import 'teacher_class_grade_model.dart';
import 'teacher_class_category_model.dart';
import 'teacher_class_enrollment_model.dart';
import 'teacher_class_schedule_model.dart';

class TeacherClassModel {
  final int id;
  final String className;
  final String? classType;
  final String? medium;

  final bool isActive;
  final bool isOngoing;

  final TeacherClassSubjectModel? subject;
  final TeacherClassGradeModel? grade;

  final List<TeacherClassCategoryModel> categories;
  final List<TeacherClassEnrollmentModel> enrollments;
  final List<TeacherClassScheduleModel> schedules;

  final double? teacherPercentage;

  const TeacherClassModel({
    required this.id,
    required this.className,
    this.classType,
    this.medium,
    required this.isActive,
    required this.isOngoing,
    this.subject,
    this.grade,
    required this.categories,
    required this.enrollments,
    required this.schedules,
    this.teacherPercentage,
  });

  int get studentCount {
    return enrollments.length;
  }

  factory TeacherClassModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final paymentConfig =
        json['payment_config'] is Map<String, dynamic>
            ? json['payment_config'] as Map<String, dynamic>
            : null;

    return TeacherClassModel(
      id: json['id'] ?? 0,

      className: json['class_name']?.toString() ?? '',

      classType: json['class_type']?.toString(),

      medium: json['medium']?.toString(),

      isActive: json['is_active'] == true,

      isOngoing: json['is_ongoing'] == true,

      subject: json['subject'] is Map<String, dynamic>
          ? TeacherClassSubjectModel.fromJson(
              json['subject'] as Map<String, dynamic>,
            )
          : null,

      grade: json['grade'] is Map<String, dynamic>
          ? TeacherClassGradeModel.fromJson(
              json['grade'] as Map<String, dynamic>,
            )
          : null,

      categories: (json['categories'] as List<dynamic>? ?? [])
          .map(
            (item) => TeacherClassCategoryModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),

      enrollments: (json['enrollments'] as List<dynamic>? ?? [])
          .map(
            (item) => TeacherClassEnrollmentModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),

      schedules: (json['schedules'] as List<dynamic>? ?? [])
          .map(
            (item) => TeacherClassScheduleModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),

      teacherPercentage:
          paymentConfig != null &&
                  paymentConfig['teacher_percentage'] != null
              ? double.tryParse(
                  paymentConfig['teacher_percentage'].toString(),
                )
              : null,
    );
  }
}