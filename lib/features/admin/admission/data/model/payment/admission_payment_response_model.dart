import 'admission_payment_model.dart';
import 'admission_summary_model.dart';
import 'admission_unpaid_student_model.dart';

class AdmissionPaymentResponseModel {
  final AdmissionSummaryModel summary;

  final List<AdmissionPaymentModel> paidStudents;

  final List<AdmissionUnpaidStudentModel> unpaidStudents;

  const AdmissionPaymentResponseModel({
    required this.summary,
    required this.paidStudents,
    required this.unpaidStudents,
  });

  factory AdmissionPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return AdmissionPaymentResponseModel(
      summary: AdmissionSummaryModel.fromJson(json['summary']),

      paidStudents: (json['paid_students'] as List)
          .map((e) => AdmissionPaymentModel.fromJson(e))
          .toList(),

      unpaidStudents: (json['unpaid_students'] as List)
          .map((e) => AdmissionUnpaidStudentModel.fromJson(e))
          .toList(),
    );
  }
}
