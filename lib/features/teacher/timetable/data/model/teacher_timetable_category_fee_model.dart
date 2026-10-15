class TeacherTimetableCategoryFeeModel {
  final int id;
  final bool isActive;

  const TeacherTimetableCategoryFeeModel({
    required this.id,
    required this.isActive,
  });

  factory TeacherTimetableCategoryFeeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherTimetableCategoryFeeModel(
      id: _toInt(json['id']),

      isActive: json['is_active'] == true,
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