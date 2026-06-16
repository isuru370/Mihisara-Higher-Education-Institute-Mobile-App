class QuickPhotoDataModel {
  final String customId;
  final String imagePath;
  final String imageUrl;

  QuickPhotoDataModel({
    required this.customId,
    required this.imagePath,
    required this.imageUrl,
  });

  factory QuickPhotoDataModel.fromJson(Map<String, dynamic> json) {
    return QuickPhotoDataModel(
      customId: json["custom_id"] ?? '',
      imagePath: json["image_path"] ?? '',
      imageUrl: json["image_url"] ?? '',
    );
  }
}