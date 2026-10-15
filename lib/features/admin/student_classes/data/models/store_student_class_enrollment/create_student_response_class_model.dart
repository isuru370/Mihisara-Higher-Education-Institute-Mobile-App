class CreateStudentClassResponseModel {
  final bool success;
  final String? message;

  CreateStudentClassResponseModel({required this.success, this.message});

  factory CreateStudentClassResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateStudentClassResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }

  bool get isSuccess => success;
}
