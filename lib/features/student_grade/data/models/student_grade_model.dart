class StudentGradeModel {
  final int gradeId;
  final String gradeName;

  const StudentGradeModel({
    required this.gradeId,
    required this.gradeName,
  });

  factory StudentGradeModel.fromJson(Map<String, dynamic> json) {
    return StudentGradeModel(
      gradeId: json['id'] ?? 0,
      gradeName: json['grade_name'] ?? '',
    );
  }
}
