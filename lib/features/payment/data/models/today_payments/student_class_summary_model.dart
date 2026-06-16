import 'class_category_model.dart';
import 'grade_summary_model.dart';
import 'subject_summary_model.dart';
import 'teacher_summary_model.dart';

class StudentClassSummaryModel {
  final int id;
  final String className;
  final ClassCategoryModel? category; // Renamed from categoryModel
  final GradeSummaryModel grade;
  final SubjectSummaryModel subject;
  final TeacherSummaryModel teacher;

  StudentClassSummaryModel({
    required this.id,
    required this.className,
    this.category, // Renamed
    required this.grade,
    required this.subject,
    required this.teacher,
  });

  factory StudentClassSummaryModel.fromJson(Map<String, dynamic> json) {
    return StudentClassSummaryModel(
      id: json['id'] ?? 0,
      className: json['class_name'] ?? '',
      category: json['category'] != null
          ? ClassCategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      grade: GradeSummaryModel.fromJson(json['grade'] as Map<String, dynamic>),
      subject: SubjectSummaryModel.fromJson(json['subject'] as Map<String, dynamic>),
      teacher: TeacherSummaryModel.fromJson(json['teacher'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_name': className,
      'category': category?.toJson(),
      'grade': grade.toJson(),
      'subject': subject.toJson(),
      'teacher': teacher.toJson(),
    };
  }
}