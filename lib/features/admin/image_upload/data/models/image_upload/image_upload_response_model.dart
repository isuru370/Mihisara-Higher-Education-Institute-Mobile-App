class ImageUploadDataModel {
  final String customId;
  final String imagePath;
  final String imageUrl;

  const ImageUploadDataModel({
    required this.customId,
    required this.imagePath,
    required this.imageUrl,
  });

  factory ImageUploadDataModel.fromJson(Map<String, dynamic> json) {
    return ImageUploadDataModel(
      customId: json['custom_id']?.toString() ?? '',
      imagePath: json['image_path']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
    );
  }
}

class ImageUploadResponseModel {
  final bool success;
  final String message;
  final ImageUploadDataModel? data;

  const ImageUploadResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ImageUploadResponseModel.fromJson(Map<String, dynamic> json) {
    return ImageUploadResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] != null
          ? ImageUploadDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}