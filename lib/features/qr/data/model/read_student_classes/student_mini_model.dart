import '../../../../../core/constants/api_constants.dart';

class StudentMiniModel {
  final int id;
  final String? customId;
  final String? temporaryQrCode;
  final String? initialName;
  final String? imgUrl;
  final int? gradeId;
  final String? gradeName;

  StudentMiniModel({
    required this.id,
    this.customId,
    this.temporaryQrCode,
    this.initialName,
    this.imgUrl,
    this.gradeId,
    this.gradeName,
  });

  factory StudentMiniModel.fromJson(Map<String, dynamic> json) {
    final rawPath = json['img_url']?.toString();
    return StudentMiniModel(
      id: _parseInt(json['id']),
      customId: json['custom_id']?.toString(),
      temporaryQrCode: json['temporary_qr_code']?.toString(),
      initialName: json['initial_name']?.toString(),
      imgUrl: rawPath == null || rawPath.isEmpty
          ? null
          : rawPath.startsWith('http')
          ? rawPath
          : '${ApiConstants.baseUrl.replaceAll(RegExp(r'/$'), '')}/storage/$rawPath',
      gradeId: json['grade_id'] != null ? _parseInt(json['grade_id']) : null,
      gradeName: json['grade_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'custom_id': customId,
      'temporary_qr_code': temporaryQrCode,
      'initial_name': initialName,
      'img_url': imgUrl,
      'grade_id': gradeId,
      'grade_name': gradeName,
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }
}
