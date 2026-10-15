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

  const OngoingClassModel({
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
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      className: json['class_name']?.toString() ?? '',
      classType: json['class_type']?.toString() ?? '',
      medium: json['medium']?.toString() ?? '',
      teacherId: int.tryParse(json['teacher_id']?.toString() ?? '0') ?? 0,
      subjectId: int.tryParse(json['subject_id']?.toString() ?? '0') ?? 0,
      gradeId: int.tryParse(json['grade_id']?.toString() ?? '0') ?? 0,
      isActive: json['is_active'] == true,
      isOngoing: json['is_ongoing'] == true,
      teacher: json['teacher'] is Map<String, dynamic>
          ? TeacherMiniModel.fromJson(json['teacher'] as Map<String, dynamic>)
          : TeacherMiniModel(id: 0, customId: '', initials: ''),
      subject: json['subject'] is Map<String, dynamic>
          ? SubjectModel.fromJson(json['subject'] as Map<String, dynamic>)
          : SubjectModel(id: 0, subjectName: ''),
      grade: json['grade'] is Map<String, dynamic>
          ? GradeModel.fromJson(json['grade'] as Map<String, dynamic>)
          : GradeModel(id: 0, gradeName: ''),
    );
  }
}
