import '../../../../core/constants/api_constants.dart';

class StudentMiniModel {
  final String initialName;
  final String? imgUrl;
  final String grade;
  final String guardianMobile;

  const StudentMiniModel({
    required this.initialName,
    this.imgUrl,
    required this.grade,
    required this.guardianMobile,
  });

  factory StudentMiniModel.fromJson(Map<String, dynamic> json) {
    final rawPath = json['img_url']?.toString();

    return StudentMiniModel(
      initialName: json['initial_name']?.toString() ?? '',
      imgUrl: rawPath == null || rawPath.isEmpty
          ? null
          : rawPath.startsWith('http')
          ? rawPath
          : '${ApiConstants.baseUrl.replaceAll(RegExp(r'/$'), '')}/storage/$rawPath',
      grade: json['grade']?.toString() ?? '',
      guardianMobile: json['guardian_mobile']?.toString() ?? '',
    );
  }
}
