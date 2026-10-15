import 'scan_payment_class_model.dart';
import 'scan_payment_student_model.dart';

class ScanPaymentResponseModel {
  final ScanPaymentStudentModel? student;
  final List<ScanPaymentClassModel> classes;

  const ScanPaymentResponseModel({
    this.student,
    this.classes = const [],
  });

  factory ScanPaymentResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final classesJson = json['classes'];

    return ScanPaymentResponseModel(
      student: json['student'] is Map
          ? ScanPaymentStudentModel.fromJson(
              Map<String, dynamic>.from(json['student']),
            )
          : null,

      classes: classesJson is List
          ? classesJson
              .whereType<Map>()
              .map(
                (item) => ScanPaymentClassModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : const [],
    );
  }
}