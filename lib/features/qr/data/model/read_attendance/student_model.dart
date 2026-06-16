import '../../../../../core/constants/api_constants.dart';

class StudentModel {
  final int id;

  final String customId;
  final String initialName;
  final String? mobile;
  final String guardianMobile;
  final String? imgUrl;
  final String qrType;

  StudentModel({
    required this.id,
    required this.customId,
    required this.initialName,
    this.mobile,
    required this.guardianMobile,
    this.imgUrl,
    required this.qrType,
  });

  factory StudentModel.fromJson(Map<String, dynamic>? json) {
    final rawPath = json?['img_url']?.toString();

    return StudentModel(
      id: (json?['id'] as num?)?.toInt() ?? 0,
      customId: json?['custom_id'] as String? ?? '',
      initialName: json?['initial_name'] as String? ?? '',
      mobile: json?['mobile'] as String? ?? '',
      guardianMobile: json?['guardian_mobile'] as String? ?? '',
      imgUrl: rawPath == null || rawPath.isEmpty
          ? null
          : rawPath.startsWith('http')
              ? rawPath
              : '${ApiConstants.baseUrl.replaceAll(RegExp(r'/$'), '')}/storage/$rawPath',
      qrType: json?['qr_type'] as String? ?? '',
    );
  }
}