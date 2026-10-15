import 'dashboard_category_model.dart';
import 'dashboard_grade_model.dart';
import 'dashboard_subject_model.dart';

class TeacherClassModel {
  final int id;
  final String? className;
  final String? classType;
  final String? medium;
  final bool isActive;
  final bool isOngoing;

  final DashboardSubjectModel? subject;
  final DashboardGradeModel? grade;

  final List<DashboardCategoryModel> categories;

  final int studentCount;
  final double teacherPercentage;

  const TeacherClassModel({
    required this.id,
    this.className,
    this.classType,
    this.medium,
    required this.isActive,
    required this.isOngoing,
    this.subject,
    this.grade,
    required this.categories,
    required this.studentCount,
    required this.teacherPercentage,
  });

  factory TeacherClassModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherClassModel(
      id: (json['id'] as num?)?.toInt() ?? 0,

      className: json['class_name'] as String?,

      classType: json['class_type'] as String?,

      medium: json['medium'] as String?,

      isActive: json['is_active'] as bool? ?? false,

      isOngoing: json['is_ongoing'] as bool? ?? false,

      subject: json['subject'] != null
          ? DashboardSubjectModel.fromJson(
              json['subject'] as Map<String, dynamic>,
            )
          : null,

      grade: json['grade'] != null
          ? DashboardGradeModel.fromJson(
              json['grade'] as Map<String, dynamic>,
            )
          : null,

      categories: (json['categories'] as List<dynamic>? ?? [])
          .map(
            (item) => DashboardCategoryModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),

      studentCount:
          (json['student_count'] as num?)?.toInt() ?? 0,

      teacherPercentage:
          (json['teacher_percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}