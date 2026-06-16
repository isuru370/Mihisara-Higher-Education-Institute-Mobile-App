import 'read_tute_enrollment_model.dart';
import 'read_tute_student_model.dart';

class ReadTuteDataModel {
  final ReadTuteStudentModel? student;
  final int year;
  final int month;
  final List<ReadTuteEnrollmentModel> enrollments;

  ReadTuteDataModel({
    this.student,
    required this.year,
    required this.month,
    required this.enrollments,
  });

  factory ReadTuteDataModel.fromJson(Map<String, dynamic> json) {
    return ReadTuteDataModel(
      student: json['student'] != null
          ? ReadTuteStudentModel.fromJson(json['student'])
          : null,
      year: json['year'] ?? 0,
      month: json['month'] ?? 0,
      enrollments: json['enrollments'] != null
          ? (json['enrollments'] as List)
              .map((e) => ReadTuteEnrollmentModel.fromJson(e))
              .toList()
          : [],
    );
  }
}