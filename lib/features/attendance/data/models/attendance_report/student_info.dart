import '../../../../../core/constants/api_constants.dart';

class StudentInfo {
  final int id;
  final String studentCode;
  final String initialName;
  final String guardianMobile;
  final String imgUrl;
  final String grade;

  StudentInfo({
    required this.id,
    required this.studentCode,
    required this.initialName,
    required this.guardianMobile,
    required this.imgUrl,
    required this.grade,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    final rawPath = json['img_url']?.toString();
    
    // Properly format the image URL
    String formattedImageUrl = '';
    if (rawPath != null && rawPath.isNotEmpty) {
      if (rawPath.startsWith('http')) {
        formattedImageUrl = rawPath;
      } else {
        // Remove trailing slashes from base URL
        final baseUrl = ApiConstants.baseUrl.replaceAll(RegExp(r'/$'), '');
        // Remove leading slashes from path
        final cleanPath = rawPath.replaceAll(RegExp(r'^/'), '');
        formattedImageUrl = '$baseUrl/storage/$cleanPath';
      }
    }

    return StudentInfo(
      id: json['id'] ?? 0,
      studentCode: json['student_code'] ?? '',
      initialName: json['initial_name'] ?? '',
      guardianMobile: json['guardian_mobile'] ?? '',
      imgUrl: formattedImageUrl,
      grade: json['grade'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_code': studentCode,
      'initial_name': initialName,
      'guardian_mobile': guardianMobile,
      'img_url': imgUrl,
      'grade': grade,
    };
  }
}