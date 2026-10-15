class TeacherStudentCategoryModel {
  final int id;
  final String? name;
  final String? code;

  const TeacherStudentCategoryModel({required this.id, this.name, this.code});

  factory TeacherStudentCategoryModel.fromJson(Map<String, dynamic> json) {
    return TeacherStudentCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'],
      code: json['code'],
    );
  }
}
