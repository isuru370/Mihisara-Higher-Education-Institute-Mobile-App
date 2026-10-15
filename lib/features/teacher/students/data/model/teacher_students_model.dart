import 'teacher_student_class_model.dart';

class TeacherStudentsModel {
  final TeacherStudentsSummaryModel summary;
  final List<TeacherStudentClassModel> classes;

  const TeacherStudentsModel({required this.summary, required this.classes});

  factory TeacherStudentsModel.fromJson(Map<String, dynamic> json) {
    return TeacherStudentsModel(
      summary: TeacherStudentsSummaryModel.fromJson(
        json['summary'] as Map<String, dynamic>? ?? {},
      ),
      classes: (json['classes'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                TeacherStudentClassModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class TeacherStudentsSummaryModel {
  final int totalStudents;
  final int totalClasses;

  const TeacherStudentsSummaryModel({
    required this.totalStudents,
    required this.totalClasses,
  });

  factory TeacherStudentsSummaryModel.fromJson(Map<String, dynamic> json) {
    return TeacherStudentsSummaryModel(
      totalStudents: json['total_students'] ?? 0,
      totalClasses: json['total_classes'] ?? 0,
    );
  }
}
