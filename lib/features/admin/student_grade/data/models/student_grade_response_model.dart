import 'student_grade_model.dart';

class StudentGradeResponseModel {
  final String status;
  final List<StudentGradeModel> studentGradeList;

  const StudentGradeResponseModel({
    required this.status,
    required this.studentGradeList,
  });

  factory StudentGradeResponseModel.fromJson(Map<String, dynamic> json) {
    final dataList = (json['data'] as List<dynamic>? ?? [])
        .map((e) => StudentGradeModel.fromJson(e))
        .toList();

    return StudentGradeResponseModel(
      status: json['status'] ?? 'unknown',
      studentGradeList: dataList,
    );
  }
}
