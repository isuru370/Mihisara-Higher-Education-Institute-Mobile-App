import '../../../../../core/constants/api_constants.dart';

class ReadStudentPaymentModel {
  final int id;
  final String customId;
  final String initialName;
  final String? mobile;
  final String guardianMobile;
  final String? imgUrl;
  final String qrType;

  ReadStudentPaymentModel({
    required this.id,
    required this.customId,
    required this.initialName,
    required this.mobile,
    required this.guardianMobile,
    this.imgUrl,
    required this.qrType,
  });

  factory ReadStudentPaymentModel.fromJson(Map<String, dynamic> json) {
    final rawPath = json['img_url']?.toString();

    return ReadStudentPaymentModel(
      id: json['id'] ?? 0,
      customId: json['custom_id'] ?? '',
      initialName: json['initial_name'] ?? '',
      mobile: json['mobile']?.toString(),
      guardianMobile: json['guardian_mobile']?.toString() ?? '',
      imgUrl: rawPath == null || rawPath.isEmpty
          ? null
          : rawPath.startsWith('http')
          ? rawPath
          : '${ApiConstants.baseUrl.replaceAll(RegExp(r'/$'), '')}/storage/$rawPath',
      qrType: json['qr_type'] ?? '',
    );
  }
}
