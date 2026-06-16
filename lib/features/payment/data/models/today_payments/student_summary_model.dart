import '../../../../../core/constants/api_constants.dart';

class StudentSummaryModel {
  final int id;
  final String customId;
  final String initialName;
  final String guardianMobile;
  final String? imgUrl;

  StudentSummaryModel({
    required this.id,
    required this.customId,
    required this.initialName,
    required this.guardianMobile,
    this.imgUrl,
  });

  factory StudentSummaryModel.fromJson(Map<String, dynamic> json) {
    final rawPath = json['img_url']?.toString();
    return StudentSummaryModel(
      id: json['id'] ?? 0,
      customId: json['custom_id'] ?? '',
      initialName: json['initial_name'] ?? '',
      guardianMobile: json['guardian_mobile'] ?? '',
      imgUrl: rawPath == null || rawPath.isEmpty
          ? null
          : rawPath.startsWith('http')
          ? rawPath
          : '${ApiConstants.baseUrl.replaceAll(RegExp(r'/$'), '')}/storage/$rawPath',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'custom_id': customId,
      'initial_name': initialName,
      'guardian_mobile': guardianMobile,
      'img_url': imgUrl,
    };
  }
}
