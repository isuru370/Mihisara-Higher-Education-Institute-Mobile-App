import '../../../../../../core/constants/api_constants.dart';

class ScanPaymentStudentModel {
  final int? id;
  final String customId;
  final String fullName;
  final String initialName;
  final String imageUrl;
  final String? mobile;
  final String? guardianMobile;
  final String? guardianName;
  final String? grade;

  const ScanPaymentStudentModel({
    this.id,
    this.customId = '',
    this.fullName = '',
    this.initialName = '',
    this.imageUrl = '',
    this.mobile,
    this.guardianMobile,
    this.guardianName,
    this.grade,
  });

  factory ScanPaymentStudentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawPath = json['image_url']?.toString();

    return ScanPaymentStudentModel(
      id: _int(json['id']) ?? 0,

      customId:
          _string(json['custom_id']) ??
          _string(json['student_code']) ??
          '',

      fullName:
          _string(json['full_name']) ?? '',

      initialName:
          _string(json['initial_name']) ??
          _string(json['full_name']) ??
          '',

      imageUrl: _buildImageUrl(rawPath),

      mobile: _string(json['mobile']),

      guardianMobile:
          _string(json['guardian_mobile']),

      guardianName:
          _string(json['guardian_name']),

      grade:
          _string(json['grade']),
    );
  }

  // ---------------------------------------------------------------------------
  // Image URL
  // ---------------------------------------------------------------------------

  static String _buildImageUrl(String? rawPath) {
    if (rawPath == null || rawPath.trim().isEmpty) {
      return '';
    }

    final path = rawPath.trim();

    /*
    |--------------------------------------------------------------------------
    | Already Full URL
    |--------------------------------------------------------------------------
    */

    if (path.startsWith('http://') ||
        path.startsWith('https://')) {
      return path;
    }

    /*
    |--------------------------------------------------------------------------
    | Base URL
    |--------------------------------------------------------------------------
    */

    final baseUrl = ApiConstants.baseUrl.replaceAll(
      RegExp(r'/$'),
      '',
    );

    /*
    |--------------------------------------------------------------------------
    | Backend may return:
    |
    | storage/uploads/students/xxx.jpg
    |
    | or:
    |
    | uploads/students/xxx.jpg
    |
    | or:
    |
    | students/xxx.jpg
    |--------------------------------------------------------------------------
    */

    if (path.startsWith('storage/')) {
      return '$baseUrl/$path';
    }

    return '$baseUrl/storage/$path';
  }

  // ---------------------------------------------------------------------------
  // String Parser
  // ---------------------------------------------------------------------------

  static String? _string(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    return text.isEmpty ? null : text;
  }

  // ---------------------------------------------------------------------------
  // Integer Parser
  // ---------------------------------------------------------------------------

  static int? _int(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(
      value.toString(),
    );
  }
}