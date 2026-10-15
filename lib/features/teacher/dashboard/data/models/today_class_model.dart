import 'dashboard_category_model.dart';
import 'dashboard_grade_model.dart';
import 'dashboard_hall_model.dart';
import 'dashboard_subject_model.dart';

class TodayClassModel {
  final int id;
  final int? classId;
  final String? className;
  final String? classType;
  final String? medium;

  final DashboardSubjectModel? subject;
  final DashboardGradeModel? grade;
  final DashboardCategoryModel? category;

  final String? date;
  final String? startTime;
  final String? endTime;
  final String? status;

  final DashboardHallModel? hall;
  final String? note;

  // NEW
  final int studentCount;

  const TodayClassModel({
    required this.id,
    this.classId,
    this.className,
    this.classType,
    this.medium,
    this.subject,
    this.grade,
    this.category,
    this.date,
    this.startTime,
    this.endTime,
    this.status,
    this.hall,
    this.note,

    // NEW
    this.studentCount = 0,
  });

  factory TodayClassModel.fromJson(Map<String, dynamic> json) {
    return TodayClassModel(
      id: (json['id'] as num).toInt(),

      classId: (json['class_id'] as num?)?.toInt(),

      className: json['class_name'] as String?,

      classType: json['class_type'] as String?,

      medium: json['medium'] as String?,

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

      category: json['category'] != null
          ? DashboardCategoryModel.fromJson(
              json['category'] as Map<String, dynamic>,
            )
          : null,

      date: json['date'] as String?,

      startTime: json['start_time'] as String?,

      endTime: json['end_time'] as String?,

      status: json['status'] as String?,

      hall: json['hall'] != null
          ? DashboardHallModel.fromJson(
              json['hall'] as Map<String, dynamic>,
            )
          : null,

      note: json['note'] as String?,

      // NEW
      studentCount: (json['student_count'] as num?)?.toInt() ?? 0,
    );
  }
}