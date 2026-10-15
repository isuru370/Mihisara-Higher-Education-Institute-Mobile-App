import 'class_category_fee_data_model.dart';

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
