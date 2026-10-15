import '../students_model.dart';

class ReadStudentResponseModel {
  final bool success;
  final String message;
  final StudentModel? student;

  ReadStudentResponseModel({
    required this.success,
    required this.message,
    this.student,
  });

  factory ReadStudentResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReadStudentResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Unknown',
      student: json['student'] != null
          ? StudentModel.fromJson(
              json['student'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}