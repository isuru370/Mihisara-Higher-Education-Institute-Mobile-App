import '../../../../core/constants/api_constants.dart';

class StudentImageModel {
  final int id;
  final String customId;
  final String temporaryQrCode;
  final String initialName;
  final String guardianMobile;
  final String? imgUrl;
  final String qrCode;

  StudentImageModel({
    required this.id,
    required this.customId,
    required this.temporaryQrCode,
    required this.initialName,
    required this.guardianMobile,
    required this.imgUrl,
    required this.qrCode,
  });

  factory StudentImageModel.fromJson(Map<String, dynamic> json) {
    final rawPath = json['img_url']?.toString();

    return StudentImageModel(
      id: json['id'] ?? 0,
      customId: json['custom_id'] ?? '',
      temporaryQrCode: json['temporary_qr_code'] ?? '',
      initialName: json['initial_name'] ?? '',
      guardianMobile: json['guardian_mobile'] ?? '',
      imgUrl: rawPath == null || rawPath.isEmpty
          ? null
          : rawPath.startsWith('http')
          ? rawPath
          : '${ApiConstants.baseUrl.replaceAll(RegExp(r'/$'), '')}/storage/$rawPath',

      qrCode: json['qr_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'custom_id': customId,
      'temporary_qr_code': temporaryQrCode,
      'initial_name': initialName,
      'guardian_mobile': guardianMobile,
      'img_url': imgUrl,
      'qr_code': qrCode,
    };
  }
}
