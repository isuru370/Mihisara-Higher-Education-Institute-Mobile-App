import 'teacher_timetable_class_model.dart';
import 'teacher_timetable_summary_model.dart';

class TeacherTimetableModel {
  final String date;
  final List<TeacherTimetableClassModel> classes;
  final TeacherTimetableSummaryModel summary;

  const TeacherTimetableModel({
    required this.date,
    required this.classes,
    required this.summary,
  });

  factory TeacherTimetableModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherTimetableModel(
      date: json['date']?.toString() ?? '',

      classes: (json['classes'] as List<dynamic>? ?? [])
          .map(
            (item) => TeacherTimetableClassModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),

      summary: TeacherTimetableSummaryModel.fromJson(
        json['summary'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}