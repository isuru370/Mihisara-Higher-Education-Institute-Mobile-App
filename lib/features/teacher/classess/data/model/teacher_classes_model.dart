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

  int get studentCount => enrollments.length;

  factory TeacherClassModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherClassModel(
      id: json['id'] ?? 0,
      className: json['class_name']?.toString() ?? '',
      classType: json['class_type']?.toString(),
      medium: json['medium']?.toString(),
      isActive: json['is_active'] == true,
      isOngoing: json['is_ongoing'] == true,

      subject: json['subject'] != null
          ? TeacherClassSubjectModel.fromJson(
              json['subject'] as Map<String, dynamic>,
            )
          : null,

      grade: json['grade'] != null
          ? TeacherClassGradeModel.fromJson(
              json['grade'] as Map<String, dynamic>,
            )
          : null,

      categories: (json['categories'] as List<dynamic>? ?? [])
          .map(
            (e) => TeacherClassCategoryModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),

      enrollments: (json['enrollments'] as List<dynamic>? ?? [])
          .map(
            (e) => TeacherClassEnrollmentModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),

      schedules: (json['schedules'] as List<dynamic>? ?? [])
          .map(
            (e) => TeacherClassScheduleModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),

      teacherPercentage: json['payment_config']?['teacher_percentage'] != null
          ? double.tryParse(
              json['payment_config']['teacher_percentage'].toString(),
            )
          : null,
    );
  }
}