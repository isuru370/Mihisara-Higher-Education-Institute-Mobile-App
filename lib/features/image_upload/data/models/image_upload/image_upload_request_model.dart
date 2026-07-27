import 'dart:io';

class ImageUploadRequestModel {
  final String? studentCode;
  final File image;

  ImageUploadRequestModel({required this.image, this.studentCode});
}
