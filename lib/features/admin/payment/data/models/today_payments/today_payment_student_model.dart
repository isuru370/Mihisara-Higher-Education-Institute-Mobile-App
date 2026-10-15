import '../../../../../../core/constants/api_constants.dart';

class TodayPaymentStudentModel {
  final int id;
  final String initialName;
  final String mobile;
  final String guardianMobile;
  final String? imgUrl;
  final String qrCode;

  const TodayPaymentStudentModel({
    required this.id,
    required this.initialName,
    required this.mobile,
    required this.guardianMobile,
    required this.imgUrl,
    required this.qrCode,
  });

  factory TodayPaymentStudentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawPath = json['img_url']?.toString();

    return TodayPaymentStudentModel(
      id: int.tryParse(
            json['id']?.toString() ?? '0',
          ) ??
          0,

      initialName:
          json['initial_name']?.toString() ?? '',

      mobile:
          json['mobile']?.toString() ?? '',

      guardianMobile:
          json['guardian_mobile']?.toString() ?? '',

      imgUrl: rawPath == null || rawPath.isEmpty
          ? null
          : rawPath.startsWith('http')
              ? rawPath
              : '${ApiConstants.baseUrl.replaceAll(RegExp(r'/$'), '')}/storage/$rawPath',

      qrCode:
          json['qr_code']?.toString() ?? '',
    );
  }

  factory TodayPaymentStudentModel.empty() {
    return const TodayPaymentStudentModel(
      id: 0,
      initialName: '',
      mobile: '',
      guardianMobile: '',
      imgUrl: null,
      qrCode: '',
    );
  }
}