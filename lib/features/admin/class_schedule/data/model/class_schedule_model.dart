import 'schedule/class_category_fee_model.dart';
import 'schedule/hall_model.dart';
import 'schedule/student_class_model.dart';

class ClassScheduleModel {
  final int id;
  /// Null for a day added with "Add New Day" (no weekly pattern).
  final int? classSchedulePatternId;
  final int studentClassId;
  final int classCategoryFeeId;

  /// Null when no hall is set.
  final int? classHallId;

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
      // Null-safe: a schedule without a pattern or hall made this throw
      // "Null is not a subtype of int" and the schedule list failed.
      id: _toInt(json['id']) ?? 0,
      classSchedulePatternId: _toInt(json['class_schedule_pattern_id']),
      studentClassId: _toInt(json['student_class_id']) ?? 0,
      classCategoryFeeId: _toInt(json['class_category_fee_id']) ?? 0,
      classHallId: _toInt(json['class_hall_id']),
      classDate: json['class_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      dayOfWeek: json['day_of_week'] ?? '',
      status: json['status'] ?? '',
      isActive: json['is_active'] == true || json['is_active'] == 1,
      cancelReason: json['cancel_reason']?.toString(),
      note: json['note']?.toString(),
      hall: HallModel.fromJson(
        json['hall'] is Map<String, dynamic> ? json['hall'] : {},
      ),
      classCategoryFee:
          ClassCategoryFeeModel.fromJson(
        json['class_category_fee'] is Map<String, dynamic>
            ? json['class_category_fee']
            : {},
      ),
      studentClass:
          StudentClassModel.fromJson(
        json['student_class'] is Map<String, dynamic>
            ? json['student_class']
            : {},
      ),
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }
}
