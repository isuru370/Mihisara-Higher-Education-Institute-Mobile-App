import '../students_model.dart';

class CreateStudentRequestModel {
  final StudentModel student;

  const CreateStudentRequestModel({
    required this.student,
  });

  Map<String, dynamic> toJson() => student.toJson();
}