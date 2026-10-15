import '../students_model.dart';

class StudentsResponseModel {
  final List<StudentModel> students;

  StudentsResponseModel({required this.students});

  factory StudentsResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> studentsJson = json['data'] as List<dynamic>;

    return StudentsResponseModel(
      students: studentsJson
          .map((e) => StudentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
