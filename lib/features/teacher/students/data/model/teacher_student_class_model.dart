import 'teacher_student_category_model.dart';
import 'teacher_student_grade_model.dart';
import 'teacher_student_model.dart';
import 'teacher_student_subject_model.dart';

class TeacherStudentClassModel {
  final int id;
  final String? className;
  final String? classType;
  final String? medium;
  final TeacherStudentSubjectModel? subject;
  final TeacherStudentGradeModel? grade;
  final List<TeacherStudentCategoryModel> categories;
  final int studentsCount;
  final List<TeacherStudentModel> students;

  const TeacherStudentClassModel({
    required this.id,
    this.className,
    this.classType,
    this.medium,
    this.subject,
    this.grade,
    required this.categories,
    required this.studentsCount,
    required this.students,
  });

  factory TeacherStudentClassModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherStudentClassModel(
      id: json['id'] ?? 0,
      className: json['class_name'],
      classType: json['class_type'],
      medium: json['medium'],
      subject: json['subject'] != null
          ? TeacherStudentSubjectModel.fromJson(
              json['subject'] as Map<String, dynamic>,
            )
          : null,
      grade: json['grade'] != null
          ? TeacherStudentGradeModel.fromJson(
              json['grade'] as Map<String, dynamic>,
            )
          : null,
      categories: (json['categories'] as List<dynamic>? ?? [])
          .map(
            (item) => TeacherStudentCategoryModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      studentsCount: json['students_count'] ?? 0,
      students: (json['students'] as List<dynamic>? ?? [])
          .map(
            (item) => TeacherStudentModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}
