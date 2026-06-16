import 'read_student_class_payment_model.dart';
import 'read_student_payment_model.dart';

class ReadPaymentDataModel {
  final ReadStudentPaymentModel student;
  final List<ReadStudentClassPaymentModel> classes;

  ReadPaymentDataModel({
    required this.student,
    required this.classes,
  });

  factory ReadPaymentDataModel.fromJson(Map<String, dynamic> json) {
    return ReadPaymentDataModel(
      student: ReadStudentPaymentModel.fromJson(
        json['student'] as Map<String, dynamic>,
      ),
      classes: (json['classes'] as List<dynamic>? ?? [])
          .map((e) => ReadStudentClassPaymentModel.fromJson(
                e as Map<String, dynamic>,
              ))
          .toList(),
    );
  }
}