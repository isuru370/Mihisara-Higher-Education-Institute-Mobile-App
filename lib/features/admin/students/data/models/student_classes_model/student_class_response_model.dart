import 'student_class_model.dart';

class StudentClassResponseModel {
  final bool success;
  final List<StudentClassModel> data;

  StudentClassResponseModel({
    required this.success,
    required this.data,
  });

  factory StudentClassResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudentClassResponseModel(
      success: json['success'] == true,
      data: (json['data'] as List<dynamic>? ?? [])
          .map(
            (e) => StudentClassModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}