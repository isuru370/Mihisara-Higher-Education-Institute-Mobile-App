import '../../../../students/data/models/student_classes_model/student_class_model.dart';
import 'student_mini_model.dart';

class ReadStudentClassesResponseModel {
  final bool success;
  final String? message;
  final StudentMiniModel? student;
  final List<StudentClassModel> data;

  ReadStudentClassesResponseModel({
    required this.success,
    this.message,
    this.student,
    required this.data,
  });

  factory ReadStudentClassesResponseModel.fromJson(Map<String, dynamic> json) {
    return ReadStudentClassesResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString(),
      student: json['student'] is Map<String, dynamic>
          ? StudentMiniModel.fromJson(json['student'])
          : null,
      data: (json['data'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(StudentClassModel.fromJson)
          .toList(),
    );
  }
}
