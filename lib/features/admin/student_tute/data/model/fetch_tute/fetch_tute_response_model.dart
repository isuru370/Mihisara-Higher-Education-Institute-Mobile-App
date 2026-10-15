import 'student_tute_model.dart';

class FetchStudentTuteResponseModel {
  final bool success;
  final String message;
  final List<StudentTuteModel> data;

  FetchStudentTuteResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory FetchStudentTuteResponseModel.fromJson(Map<String, dynamic> json) {
    return FetchStudentTuteResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
              .map((e) => StudentTuteModel.fromJson(e))
              .toList()
          : [],
    );
  }
}