import '../../../../../core/constants/api_constants.dart';

class StudentModel {
  final int id;
  final String studentCode;
  final String initialName;
  final String guardianMobile;
  final String imgUrl;
  final GradeModel grade;

  StudentModel({
    required this.id,
    required this.studentCode,
    required this.initialName,
    required this.guardianMobile,
    required this.imgUrl,
    required this.grade,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    final rawPath = json['img_url']?.toString();

    return StudentModel(
      id: _int(json['id']) ?? 0,
      studentCode: _string(json['student_code']) ?? '',
      initialName: _string(json['initial_name']) ?? '',
      guardianMobile: _string(json['guardian_mobile']) ?? '',
      imgUrl: rawPath == null || rawPath.isEmpty
          ? ''
          : rawPath.startsWith('http')
          ? rawPath
          : '${ApiConstants.baseUrl.replaceAll(RegExp(r'/$'), '')}/storage/$rawPath',
      grade: GradeModel.fromJson(json['grade'] as Map<String, dynamic>),
    );
  }

  static String? _string(dynamic value) {
    if (value == null) return null;

    final text = value.toString().trim();

    return text.isEmpty ? null : text;
  }

  static int? _int(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;

    return int.tryParse(value.toString());
  }
}

class GradeModel {
  final int id;
  final String gradeName;

  GradeModel({required this.id, required this.gradeName});

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      id: StudentModel._int(json['id']) ?? 0,
      gradeName: StudentModel._string(json['grade_name']) ?? '',
    );
  }
}
