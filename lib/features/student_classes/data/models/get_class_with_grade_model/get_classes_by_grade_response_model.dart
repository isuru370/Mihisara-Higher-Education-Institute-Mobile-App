import 'student_class_data_model.dart';

class GetClassesByGradeResponseModel {
  final bool success;
  final String? message;
  final GradeInfoModel? grade;
  final List<StudentClassDataModel> data;

  GetClassesByGradeResponseModel({
    required this.success,
    this.message,
    this.grade,
    required this.data,
  });

  factory GetClassesByGradeResponseModel.fromJson(Map<String, dynamic> json) {
    return GetClassesByGradeResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString(),
      grade: json['grade'] is Map<String, dynamic>
          ? GradeInfoModel.fromJson(json['grade'])
          : null,
      data: (json['data'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(StudentClassDataModel.fromJson)
          .toList(),
    );
  }
}

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