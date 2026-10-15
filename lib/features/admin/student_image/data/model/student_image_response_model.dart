import 'student_image_model.dart';

class StudentImageResponseModel {
  final bool success;
  final List<StudentImageModel> data;

  StudentImageResponseModel({required this.success, required this.data});

  factory StudentImageResponseModel.fromJson(Map<String, dynamic> json) {
    return StudentImageResponseModel(
      success: json['success'] ?? false,

      data: json['data'] != null
          ? List<StudentImageModel>.from(
              json['data'].map((x) => StudentImageModel.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data.map((e) => e.toJson()).toList()};
  }
}
