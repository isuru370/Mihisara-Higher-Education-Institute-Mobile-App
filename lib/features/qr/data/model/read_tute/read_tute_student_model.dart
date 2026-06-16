import '../../../../../core/constants/api_constants.dart';

class ReadTuteStudentModel {
  final int id;
  final String? customId;
  final String? initialName;
  final String? guardianMobile;
  final String? imgUrl;

  ReadTuteStudentModel({
    required this.id,
    this.customId,
    this.initialName,
    this.guardianMobile,
    this.imgUrl,
  });

  factory ReadTuteStudentModel.fromJson(Map<String, dynamic> json) {
    final rawPath = json['img_url']?.toString();
    return ReadTuteStudentModel(
      id: json['id'] ?? 0,
      customId: json['custom_id'],
      initialName: json['initial_name'],
      guardianMobile: json['guardian_mobile'],
      imgUrl: rawPath == null || rawPath.isEmpty
          ? null
          : rawPath.startsWith('http')
          ? rawPath
          : '${ApiConstants.baseUrl.replaceAll(RegExp(r'/$'), '')}/storage/$rawPath',
    );
  }
}
