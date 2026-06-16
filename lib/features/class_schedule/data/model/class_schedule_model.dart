import 'schedule/class_category_fee_model.dart';
import 'schedule/hall_model.dart';
import 'schedule/student_class_model.dart';

class ClassScheduleModel {
  final int id;
  final int classSchedulePatternId;
  final int studentClassId;
  final int classCategoryFeeId;
  final int classHallId;

  final String classDate;
  final String startTime;
  final String endTime;
  final String dayOfWeek;
  final String status;

  final bool isActive;

  final String? cancelReason;
  final String? note;

  final HallModel hall;
  final ClassCategoryFeeModel classCategoryFee;
  final StudentClassModel studentClass;

  const ClassScheduleModel({
    required this.id,
    required this.classSchedulePatternId,
    required this.studentClassId,
    required this.classCategoryFeeId,
    required this.classHallId,
    required this.classDate,
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
    required this.status,
    required this.isActive,
    this.cancelReason,
    this.note,
    required this.hall,
    required this.classCategoryFee,
    required this.studentClass,
  });

  factory ClassScheduleModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClassScheduleModel(
      id: json['id'],
      classSchedulePatternId:
          json['class_schedule_pattern_id'],
      studentClassId:
          json['student_class_id'],
      classCategoryFeeId:
          json['class_category_fee_id'],
      classHallId:
          json['class_hall_id'],
      classDate: json['class_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      dayOfWeek: json['day_of_week'] ?? '',
      status: json['status'] ?? '',
      isActive: json['is_active'] ?? false,
      cancelReason: json['cancel_reason'],
      note: json['note'],
      hall: HallModel.fromJson(
        json['hall'] ?? {},
      ),
      classCategoryFee:
          ClassCategoryFeeModel.fromJson(
        json['class_category_fee'] ?? {},
      ),
      studentClass:
          StudentClassModel.fromJson(
        json['student_class'] ?? {},
      ),
    );
  }
}