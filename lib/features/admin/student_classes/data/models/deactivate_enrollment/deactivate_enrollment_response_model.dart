class DeactivateEnrollmentResponseModel {
  final bool success;
  final String message;

  const DeactivateEnrollmentResponseModel({
    required this.success,
    required this.message,
  });

  factory DeactivateEnrollmentResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DeactivateEnrollmentResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
    );
  }
}