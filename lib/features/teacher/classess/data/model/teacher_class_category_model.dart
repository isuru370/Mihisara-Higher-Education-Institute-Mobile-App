class TeacherClassCategoryModel {
  final int id;
  final String name;
  final String? code;

  const TeacherClassCategoryModel({
    required this.id,
    required this.name,
    this.code,
  });

  factory TeacherClassCategoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherClassCategoryModel(
      id: json['id'] ?? 0,

      name: json['category_name']?.toString() ??
          json['name']?.toString() ??
          '',

      code: json['code']?.toString(),
    );
  }
}