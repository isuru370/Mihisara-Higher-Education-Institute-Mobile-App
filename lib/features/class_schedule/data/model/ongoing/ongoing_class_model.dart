import 'grade_model.dart';
import 'subject_model.dart';
import 'teacher_mini_model.dart';

class OngoingClassModel {
  final int id;
  final String className;
  final String classType;
  final String medium;
  final int teacherId;
  final int subjectId;
  final int gradeId;
  final bool isActive;
  final bool isOngoing;

  final TeacherMiniModel teacher;
  final SubjectModel subject;
  final GradeModel grade;

  OngoingClassModel({
    required this.id,
    required this.className,
    required this.classType,
    required this.medium,
    required this.teacherId,
    required this.subjectId,
    required this.gradeId,
    required this.isActive,
    required this.isOngoing,
    required this.teacher,
    required this.subject,
    required this.grade,
  });

  factory OngoingClassModel.fromJson(Map<String, dynamic> json) {
    return OngoingClassModel(
      id: json['id'],
      className: json['class_name'] ?? '',
      classType: json['class_type'] ?? '',
      medium: json['medium'] ?? '',
      teacherId: json['teacher_id'],
      subjectId: json['subject_id'],
      gradeId: json['grade_id'],
      isActive: json['is_active'] ?? false,
      isOngoing: json['is_ongoing'] ?? false,
      teacher: TeacherMiniModel.fromJson(json['teacher'] ?? {}),
      subject: SubjectModel.fromJson(json['subject'] ?? {}),
      grade: GradeModel.fromJson(json['grade'] ?? {}),
    );
  }
}
