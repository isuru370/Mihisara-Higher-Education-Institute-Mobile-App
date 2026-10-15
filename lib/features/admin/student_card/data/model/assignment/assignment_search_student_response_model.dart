import 'assignment_search_student_data_model.dart';

class AssignmentSearchStudentResponseModel {
  final bool success;
  final String message;
  final AssignmentSearchStudentDataModel data;

  const AssignmentSearchStudentResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AssignmentSearchStudentResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AssignmentSearchStudentResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: AssignmentSearchStudentDataModel.fromJson(
        json['data'] ?? {},
      ),
    );
  }
}