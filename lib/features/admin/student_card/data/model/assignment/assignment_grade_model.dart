class AssignmentGradeModel {
  final int id;
  final String gradeName;

  const AssignmentGradeModel({
    required this.id,
    required this.gradeName,
  });

  factory AssignmentGradeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AssignmentGradeModel(
      id: json['id'] ?? 0,
      gradeName: json['grade_name'] ?? '',
    );
  }
}