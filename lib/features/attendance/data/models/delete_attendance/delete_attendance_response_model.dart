class DeleteAttendanceResponseModel {
  final bool success;
  final String message;

  const DeleteAttendanceResponseModel({
    required this.success,
    required this.message,
  });

  factory DeleteAttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteAttendanceResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
    );
  }
}
