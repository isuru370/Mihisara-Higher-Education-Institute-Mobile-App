class GradeModel {
  final int id;
  final String gradeName;

  GradeModel({
    required this.id,
    required this.gradeName,
  });

  factory GradeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return GradeModel(
      id: json['id'] ?? 0,
      gradeName: json['grade_name'] ?? '',
    );
  }
}