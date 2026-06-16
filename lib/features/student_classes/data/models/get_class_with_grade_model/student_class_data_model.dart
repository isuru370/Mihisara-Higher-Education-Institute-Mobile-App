class StudentClassDataModel {
  final int classId;
  final String className;
  final String classType;
  final String medium;
  final int gradeId;
  final String gradeName;
  final int? teacherId;
  final String teacherName;
  final bool isActive;
  final bool isOngoing;
  final List<ClassCategoryFeeDataModel> categoryFees;

  StudentClassDataModel({
    required this.classId,
    required this.className,
    required this.classType,
    required this.medium,
    required this.gradeId,
    required this.gradeName,
    required this.teacherId,
    required this.teacherName,
    required this.isActive,
    required this.isOngoing,
    required this.categoryFees,
  });

  factory StudentClassDataModel.fromJson(Map<String, dynamic> json) {
    return StudentClassDataModel(
      classId: _toInt(json['class_id']),
      className: json['class_name']?.toString() ?? '',
      classType: json['class_type']?.toString() ?? '',
      medium: json['medium']?.toString() ?? '',
      gradeId: _toInt(json['grade_id']),
      gradeName: json['grade_name']?.toString() ?? '',
      teacherId: json['teacher_id'] != null ? _toInt(json['teacher_id']) : null,
      teacherName: json['teacher_name']?.toString() ?? '',
      isActive: json['is_active'] == true,
      isOngoing: json['is_ongoing'] == true,
      categoryFees: (json['category_fees'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(ClassCategoryFeeDataModel.fromJson)
          .toList(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
}

class ClassCategoryFeeDataModel {
  final int classCategoryFeeId;
  final int classCategoryId;
  final String categoryName;
  final double fee;
  final bool isActive;

  ClassCategoryFeeDataModel({
    required this.classCategoryFeeId,
    required this.classCategoryId,
    required this.categoryName,
    required this.fee,
    required this.isActive,
  });

  factory ClassCategoryFeeDataModel.fromJson(Map<String, dynamic> json) {
    return ClassCategoryFeeDataModel(
      classCategoryFeeId: _toInt(json['class_category_fee_id']),
      classCategoryId: _toInt(json['class_category_id']),
      categoryName: json['category_name']?.toString() ?? '',
      fee: _toDouble(json['fee']),
      isActive: json['is_active'] == true,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}