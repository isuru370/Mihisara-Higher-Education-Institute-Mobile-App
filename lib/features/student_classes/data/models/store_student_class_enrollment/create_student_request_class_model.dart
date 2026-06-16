import 'create_student_class_enrollment_model.dart';

class CreateStudentClassRequestModel {
  final CreateStudentClassEnrollmentModel classEnrollmentModel;

  CreateStudentClassRequestModel({
    required this.classEnrollmentModel,
  });

  Map<String, dynamic> toJson() {
    return classEnrollmentModel.toJson();
  }
}