
import 'student_custom_id_model.dart';

class StudentsCustomIdResponseModel {
  final List<StudentCustomIdModel> studentCustomIds;

  StudentsCustomIdResponseModel({required this.studentCustomIds});

  factory StudentsCustomIdResponseModel.fromJson(Map<String, dynamic> json) {
    final List data = json['data'];

    return StudentsCustomIdResponseModel(
      studentCustomIds:
          data.map((e) => StudentCustomIdModel.fromJson(e)).toList(),
    );
  }
}
