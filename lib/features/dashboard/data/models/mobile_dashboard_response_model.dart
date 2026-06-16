import 'sms_balance_model.dart';

class MobileDashboardResponseModel {
  final bool success;
  final String message;
  final MobileDashboardData data;

  MobileDashboardResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MobileDashboardResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MobileDashboardResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: MobileDashboardData.fromJson(json['data']),
    );
  }
}

class MobileDashboardData {
  final SmsBalanceModel smsBalance;

  final int totalStudent;
  final int totalTeacher;
  final int totalClasses;
  final int todayClassCount;

  final dynamic todayPaymentCollection;

  final int currentMonthAdmissionCount;
  final int temporaryStudentCount;
  final int permanentStudentCount;

  final List<CurrentMonthAdmissionModel>
      currentMonthAdmissions;

  MobileDashboardData({
    required this.smsBalance,
    required this.totalStudent,
    required this.totalTeacher,
    required this.totalClasses,
    required this.todayClassCount,
    required this.todayPaymentCollection,
    required this.currentMonthAdmissionCount,
    required this.temporaryStudentCount,
    required this.permanentStudentCount,
    required this.currentMonthAdmissions,
  });

  factory MobileDashboardData.fromJson(
    Map<String, dynamic> json,
  ) {
    return MobileDashboardData(
      smsBalance: SmsBalanceModel.fromJson(
        json['sms_balance'] ?? {},
      ),

      totalStudent:
          json['total_student'] ?? 0,

      totalTeacher:
          json['total_teacher'] ?? 0,

      totalClasses:
          json['total_classes'] ?? 0,

      todayClassCount:
          json['today_class_count'] ?? 0,

      todayPaymentCollection:
          json['today_payment_collection'],

      currentMonthAdmissionCount:
          json['current_month_admission_count'] ?? 0,

      temporaryStudentCount:
          json['temporary_student_count'] ?? 0,

      permanentStudentCount:
          json['permanent_student_count'] ?? 0,

      currentMonthAdmissions:
          (json['current_month_admissions']
                      as List<dynamic>? ??
                  [])
              .map(
                (e) =>
                    CurrentMonthAdmissionModel
                        .fromJson(e),
              )
              .toList(),
    );
  }
}

class CurrentMonthAdmissionModel {
  final int id;
  final String customId;
  final String? temporaryQrCode;
  final String initialName;
  final String gender;
  final String guardianMobile;

  CurrentMonthAdmissionModel({
    required this.id,
    required this.customId,
    required this.temporaryQrCode,
    required this.initialName,
    required this.gender,
    required this.guardianMobile,
  });

  factory CurrentMonthAdmissionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CurrentMonthAdmissionModel(
      id: json['id'] ?? 0,
      customId: json['custom_id'] ?? '',
      temporaryQrCode: json['temporary_qr_code'],
      initialName: json['initial_name'] ?? '',
      gender: json['gender'] ?? '',
      guardianMobile: json['guardian_mobile'] ?? '',
    );
  }
}