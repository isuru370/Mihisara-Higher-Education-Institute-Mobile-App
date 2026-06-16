import 'hall_model.dart';

class ScheduleModel {
  final int id;
  final int classCategoryFeeId;
  final int? classSchedulePatternId;
  final DateTime classDate;
  final String startTime;
  final String endTime;
  final String status;
  final HallModel hall;

  ScheduleModel({
    required this.id,
    required this.classCategoryFeeId,
    required this.classSchedulePatternId,
    required this.classDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.hall,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      classCategoryFeeId: json['class_category_fee_id'] is int
          ? json['class_category_fee_id']
          : int.tryParse('${json['class_category_fee_id']}') ?? 0,
      classSchedulePatternId: json['class_schedule_pattern_id'] == null
          ? null
          : (json['class_schedule_pattern_id'] is int
                ? json['class_schedule_pattern_id']
                : int.tryParse('${json['class_schedule_pattern_id']}')),
      classDate:
          DateTime.tryParse(json['class_date']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      hall: HallModel.fromJson(json['hall'] as Map<String, dynamic>? ?? {}),
    );
  }
}
