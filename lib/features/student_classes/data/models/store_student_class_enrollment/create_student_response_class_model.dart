class CreateStudentClassResponseModel {
  final String? status;
  final String? message;

  CreateStudentClassResponseModel({
    this.status,
    this.message,
  });

  factory CreateStudentClassResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CreateStudentClassResponseModel(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }

  bool get isSuccess => status == 'success';
}