class TeacherTimetableCategoryModel {
  final int id;
  final String name;
  final String? code;

  const TeacherTimetableCategoryModel({
    required this.id,
    required this.name,
    this.code,
  });

  factory TeacherTimetableCategoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherTimetableCategoryModel(
      id: _toInt(json['id']),

      name: json['name']?.toString() ?? '',

      code: json['code']?.toString(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}