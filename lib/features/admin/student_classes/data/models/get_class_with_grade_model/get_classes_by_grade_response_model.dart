import 'grade_info_model.dart';
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

  factory GetClassesByGradeResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
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

