import '../../../../core/constants/api_constants.dart';

class StudentMiniModel {
  final int id;
  final String customId;
  final String fullName;
  final String initialName;
  final String guardianMobile;
  final String imageUrl;

  StudentMiniModel({
    required this.id,
    required this.customId,
    required this.fullName,
    required this.initialName,
    required this.guardianMobile,
    required this.imageUrl,
  });

  factory StudentMiniModel.fromJson(Map<String, dynamic> json) {
    return StudentMiniModel(
      id: json['id'],
      customId: json['custom_id'],
      fullName: json['first_name'],
      initialName: json['last_name'],
      guardianMobile: json['guardian_mobile'],
      imageUrl: json['img_url'].toString().replaceFirst(
        'http://127.0.0.1:8000',
        ApiConstants.baseUrl,
      ), // default image
    );
  }
}
