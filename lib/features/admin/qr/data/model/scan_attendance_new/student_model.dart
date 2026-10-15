import '../../../../../../core/constants/api_constants.dart';

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

  factory StudentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawPath = json['img_url']?.toString();

    return StudentModel(
      id: _int(json['id']) ?? 0,

      studentCode:
          _string(json['student_code']) ??
          _string(json['custom_id']) ??
          '',

      initialName:
          _string(json['initial_name']) ??
          _string(json['full_name']) ??
          '',

      guardianMobile:
          _string(json['guardian_mobile']) ?? '',

      imgUrl: _buildImageUrl(rawPath),

      grade: json['grade'] is Map<String, dynamic>
          ? GradeModel.fromJson(
              json['grade'] as Map<String, dynamic>,
            )
          : GradeModel(
              id: 0,
              gradeName: '',
            ),
    );
  }

  static String _buildImageUrl(String? rawPath) {
    if (rawPath == null || rawPath.isEmpty) {
      return '';
    }

    if (rawPath.startsWith('http')) {
      return rawPath;
    }

    final baseUrl = ApiConstants.baseUrl.replaceAll(
      RegExp(r'/$'),
      '',
    );

    /*
    |--------------------------------------------------------------------------
    | Backend may return:
    |
    | uploads/students/xxx.jpg
    |
    | or:
    |
    | students/xxx.jpg
    |
    |--------------------------------------------------------------------------
    */

    if (rawPath.startsWith('storage/')) {
      return '$baseUrl/$rawPath';
    }

    return '$baseUrl/storage/$rawPath';
  }

  static String? _string(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    return text.isEmpty ? null : text;
  }

  static int? _int(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(value.toString());
  }
}

class GradeModel {
  final int id;
  final String gradeName;

  GradeModel({
    required this.id,
    required this.gradeName,
  });

  factory GradeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return GradeModel(
      id: StudentModel._int(json['id']) ?? 0,
      gradeName:
          StudentModel._string(json['grade_name']) ?? '',
    );
  }
}