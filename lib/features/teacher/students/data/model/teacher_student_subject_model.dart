class TeacherStudentSubjectModel {
  final int id;
  final String? name;

  const TeacherStudentSubjectModel({
    required this.id,
    this.name,
  });

  factory TeacherStudentSubjectModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherStudentSubjectModel(
      id: json['id'] ?? 0,
      name: json['name'],
    );
  }
}
