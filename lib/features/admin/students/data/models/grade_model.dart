class GradeModel {
  final int? gradeId; // nullable
  final String gradeName;

  GradeModel({this.gradeId, required this.gradeName});

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      gradeId: json['id'] != null ? json['id'] as int : null,
      gradeName: json['grade_name'] ?? 'N/A',
    );
  }
}
