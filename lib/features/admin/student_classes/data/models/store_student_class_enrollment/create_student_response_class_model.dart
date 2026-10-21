class CreateStudentClassResponseModel {
  final bool success;
  final String? message;

  CreateStudentClassResponseModel({required this.success, this.message});

  factory CreateStudentClassResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateStudentClassResponseModel(
      // The API answers {"status": "success", "message": ...} (201);
      // there is no "success" key, so a saved enrollment looked failed.
      success: json['success'] == true ||
          json['status']?.toString().toLowerCase() == 'success',
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }

  bool get isSuccess => success;
}
