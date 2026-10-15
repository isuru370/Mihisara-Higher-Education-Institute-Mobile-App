class ImageUpdateResponseModel {
  final bool success;
  final String message;

  ImageUpdateResponseModel({
    required this.success,
    required this.message,
  });

  factory ImageUpdateResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ImageUpdateResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
    );
  }
}