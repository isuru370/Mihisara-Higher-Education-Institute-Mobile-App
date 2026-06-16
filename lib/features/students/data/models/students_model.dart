import 'package:nexorait_education_app/features/students/data/models/portal_login_model.dart';

import '../../../../core/constants/api_constants.dart';
import 'grade_model.dart';

class StudentModel {
  final int? id;

  final String? temporaryQrCode;
  final DateTime? temporaryQrCodeExpireDate;

  final String? customId;

  final String? fullName;
  final String initialName;

  final String? mobile;
  final String? whatsappMobile;
  final String? email;

  final String? nic;
  final DateTime? bday;

  final String gender;

  final String? address1;
  final String? address2;
  final String? address3;

  final String? guardianFname;
  final String? guardianLname;
  final String? guardianNic;
  final String guardianMobile;

  final int gradeId;
  final String? classType;

  final int? admission;

  final String? studentSchool;
  final String? imgUrl;
  final DateTime? lastImageUpdateAt;

  final bool? isActive;
  final bool? permanentQrActive;
  final bool? studentDisable;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final String? quickImageId;

  final GradeModel? grade;
  final PortalLoginModel? portalLogin;

  StudentModel({
    this.id,
    this.temporaryQrCode,
    this.temporaryQrCodeExpireDate,
    this.customId,
    this.fullName,
    required this.initialName,
    this.mobile,
    this.whatsappMobile,
    this.email,
    this.nic,
    this.bday,
    required this.gender,
    this.address1,
    this.address2,
    this.address3,
    this.guardianFname,
    this.guardianLname,
    this.guardianNic,
    required this.guardianMobile,
    required this.gradeId,
    this.classType,
    this.admission,
    this.studentSchool,
    this.imgUrl,
    this.lastImageUpdateAt,
    this.isActive,
    this.permanentQrActive,
    this.studentDisable,
    this.createdAt,
    this.updatedAt,
    this.quickImageId,
    this.grade,
    this.portalLogin,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    final rawPath = json['img_url']?.toString();

    return StudentModel(
      id: _int(json['id']),
      temporaryQrCode: _string(json['temporary_qr_code']),
      temporaryQrCodeExpireDate: _parseDate(
        json['temporary_qr_code_expire_date'],
      ),
      customId: _string(json['custom_id']),
      fullName: _string(json['full_name']),
      initialName: _string(json['initial_name']) ?? '',
      mobile: _string(json['mobile']),
      whatsappMobile: _string(json['whatsapp_mobile']),
      email: _string(json['email']),
      nic: _string(json['nic']),
      bday: _parseDate(json['bday']),
      gender: _string(json['gender']) ?? 'other',
      address1: _string(json['address1']),
      address2: _string(json['address2']),
      address3: _string(json['address3']),
      guardianFname: _string(json['guardian_fname']),
      guardianLname: _string(json['guardian_lname']),
      guardianNic: _string(json['guardian_nic']),
      guardianMobile: _string(json['guardian_mobile']) ?? '',
      gradeId: _int(json['grade_id']) ?? 0,
      classType: _string(json['class_type']),
      admission: _int(json['admission']),
      studentSchool: _string(json['student_school']),
      imgUrl: rawPath == null || rawPath.isEmpty
          ? null
          : rawPath.startsWith('http')
          ? rawPath
          : '${ApiConstants.baseUrl.replaceAll(RegExp(r'/$'), '')}/storage/$rawPath',
      lastImageUpdateAt: _parseDate(json['last_image_update_at']),
      isActive: _bool(json['is_active']),
      permanentQrActive: _bool(json['permanent_qr_active']),
      studentDisable: _bool(json['student_disable']),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),

      grade: json['grade'] != null
          ? GradeModel.fromJson(json['grade'] as Map<String, dynamic>)
          : null,

      portalLogin: json['portal_login'] != null
          ? PortalLoginModel.fromJson(
              json['portal_login'] as Map<String, dynamic>,
            )
          : null,
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

  static bool? _bool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;

    final text = value.toString().toLowerCase().trim();
    if (text == '1' || text == 'true') return true;
    if (text == '0' || text == 'false') return false;

    return null;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty) return null;
    return DateTime.tryParse(text);
  }

  Map<String, dynamic> toJson() {
    return {
      'temporary_qr_code': temporaryQrCode,
      'quick_image_id': quickImageId,
      'initial_name': initialName,
      'guardian_mobile': guardianMobile,
      'grade_id': gradeId,
      'gender': gender,
      'admission_id': admission,
    };
  }
}
