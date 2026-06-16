import 'grade_model.dart';
import 'subject_model.dart';
import 'teacher_model.dart';

class StudentClassModel {
  final int id;
  final String className;
  final String classType;
  final String medium;
  final GradeModel grade;
  final SubjectModel subject;
  final TeacherModel teacher;

  StudentClassModel({
    required this.id,
    required this.className,
    required this.classType,
    required this.medium,
    required this.grade,
    required this.subject,
    required this.teacher,
  });

  factory StudentClassModel.fromJson(Map<String, dynamic> json) {
    return StudentClassModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      className: json['class_name']?.toString() ?? '',
      classType: json['class_type']?.toString() ?? '',
      medium: json['medium']?.toString() ?? '',
      grade: GradeModel.fromJson(json['grade'] as Map<String, dynamic>? ?? {}),
      subject: SubjectModel.fromJson(json['subject'] as Map<String, dynamic>? ?? {}),
      teacher: TeacherModel.fromJson(json['teacher'] as Map<String, dynamic>? ?? {}),
    );
  }
}