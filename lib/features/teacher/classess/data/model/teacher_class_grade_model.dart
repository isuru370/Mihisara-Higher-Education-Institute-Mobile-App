class TeacherClassGradeModel {
  final int id;
  final String name;

  const TeacherClassGradeModel({
    required this.id,
    required this.name,
  });

  factory TeacherClassGradeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherClassGradeModel(
      id: json['id'] ?? 0,
      name: json['grade_name']?.toString() ??
          json['name']?.toString() ??
          '',
    );
  }
}