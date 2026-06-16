class QuickPhotoModel {
  final String customId;
  final String imagePath;
  final String imageUrl;

  QuickPhotoModel({
    required this.customId,
    required this.imagePath,
    required this.imageUrl,
  });

  factory QuickPhotoModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"] ?? {};

    return QuickPhotoModel(
      customId: data["custom_id"] ?? '',
      imagePath: data["image_path"] ?? '',
      imageUrl: data["image_url"] ?? '',
    );
  }
}