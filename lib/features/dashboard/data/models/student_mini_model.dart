import '../../../../core/constants/api_constants.dart';

class StudentMiniModel {
  final int id;
  final String customId;
  final String fullName;
  final String initialName;
  final String? imgUrl;
  final String? classType;
  final bool admission; // ✅ bool not String

  StudentMiniModel({
    required this.id,
    required this.customId,
    required this.fullName,
    required this.initialName,
    this.imgUrl,
    this.classType,
    required this.admission,
  });

  factory StudentMiniModel.fromJson(Map<String, dynamic> json) {
    return StudentMiniModel(
      id: json['id'],
      customId: json['custom_id'],
      fullName: json['full_name'], // ✅ changed
      initialName: json['initial_name'], // ✅ changed
      imgUrl: json['img_url']?.toString().replaceFirst(
        'http://127.0.0.1:8000',
        ApiConstants.baseUrl,
      ),
      classType: json['class_type'],
      admission: json['admission'] ?? false, // ✅ bool
    );
  }
}
