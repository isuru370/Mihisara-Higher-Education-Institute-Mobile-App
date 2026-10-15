class TeacherStudentGradeModel {
  final int id;
  final String? name;

  const TeacherStudentGradeModel({required this.id, this.name});

  factory TeacherStudentGradeModel.fromJson(Map<String, dynamic> json) {
    return TeacherStudentGradeModel(id: json['id'] ?? 0, name: json['name']);
  }
}
