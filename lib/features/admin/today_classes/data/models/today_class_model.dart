import 'category_fee_model.dart';
import 'grade_model.dart';
import 'schedule_model.dart';
import 'subject_model.dart';
import 'teacher_model.dart';

class TodayClassModel {
  final int id;
  final String className;
  final String classType;
  final String medium;

  final GradeModel grade;
  final SubjectModel subject;
  final TeacherModel teacher;

  final List<CategoryFeeModel> categoryFees;
  final List<ScheduleModel> schedules;

  TodayClassModel({
    required this.id,
    required this.className,
    required this.classType,
    required this.medium,
    required this.grade,
    required this.subject,
    required this.teacher,
    required this.categoryFees,
    required this.schedules,
  });

  factory TodayClassModel.fromJson(Map<String, dynamic> json) {
    return TodayClassModel(
      id: json['id'],
      className: json['class_name'] ?? '',
      classType: json['class_type'] ?? '',
      medium: json['medium'] ?? '',
      grade: GradeModel.fromJson(json['grade']),
      subject: SubjectModel.fromJson(json['subject']),
      teacher: TeacherModel.fromJson(json['teacher']),
      categoryFees: (json['category_fees'] as List)
          .map((e) => CategoryFeeModel.fromJson(e))
          .toList(),
      schedules: (json['schedules'] as List)
          .map((e) => ScheduleModel.fromJson(e))
          .toList(),
    );
  }
}
