import 'teacher_class_model.dart';
import 'teacher_dashboard_summary_model.dart';
import 'teacher_dashboard_teacher_model.dart';
import 'today_class_model.dart';

class TeacherDashboardModel {
  final TeacherDashboardTeacherModel teacher;
  final TeacherDashboardSummaryModel summary;
  final List<TodayClassModel> todayClasses;
  final List<TeacherClassModel> classes;

  const TeacherDashboardModel({
    required this.teacher,
    required this.summary,
    required this.todayClasses,
    required this.classes,
  });

  factory TeacherDashboardModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherDashboardModel(
      teacher: TeacherDashboardTeacherModel.fromJson(
        (json['teacher'] as Map<String, dynamic>?) ?? {},
      ),

      summary: TeacherDashboardSummaryModel.fromJson(
        (json['summary'] as Map<String, dynamic>?) ?? {},
      ),

      todayClasses: (json['today_classes'] as List<dynamic>? ?? [])
          .map(
            (item) => TodayClassModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),

      classes: (json['classes'] as List<dynamic>? ?? [])
          .map(
            (item) => TeacherClassModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}