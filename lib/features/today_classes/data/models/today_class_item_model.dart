import 'category_fee_model.dart';
import 'schedule_model.dart';
import 'student_class_model.dart';

class TodayClassItemModel {
  final StudentClassModel studentClass;
  final CategoryFeeModel categoryFee;
  final ScheduleModel schedule;

  TodayClassItemModel({
    required this.studentClass,
    required this.categoryFee,
    required this.schedule,
  });

  factory TodayClassItemModel.fromJson(Map<String, dynamic> json) {
    return TodayClassItemModel(
      studentClass: StudentClassModel.fromJson(
        json['student_class'] as Map<String, dynamic>? ?? {},
      ),
      categoryFee: CategoryFeeModel.fromJson(
        json['category_fee'] as Map<String, dynamic>? ?? {},
      ),
      schedule: ScheduleModel.fromJson(
        json['schedule'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}