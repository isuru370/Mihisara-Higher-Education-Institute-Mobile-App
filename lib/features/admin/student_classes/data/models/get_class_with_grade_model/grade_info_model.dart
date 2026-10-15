class GradeInfoModel {
  final int id;
  final String gradeName;

  GradeInfoModel({
    required this.id,
    required this.gradeName,
  });

  factory GradeInfoModel.fromJson(Map<String, dynamic> json) {
    return GradeInfoModel(
      id: _toInt(json['id']),
      gradeName: json['grade_name']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
}