import 'quick_photo_data_model.dart';

class QuickPhotoResponseModel {
  final String status;
  final String message;
  final QuickPhotoDataModel data;

  QuickPhotoResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory QuickPhotoResponseModel.fromJson(Map<String, dynamic> json) {
    return QuickPhotoResponseModel(
      status: json["status"],
      message: json["message"],
      data: QuickPhotoDataModel.fromJson(json["data"]),
    );
  }
}
