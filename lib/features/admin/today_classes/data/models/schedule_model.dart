import 'hall_model.dart';

class ScheduleModel {
  final int id;
  final int classCategoryFeeId;
  final int classSchedulePatternId;
  final String classDate;
  final String startTime;
  final String endTime;
  final String status;
  final HallModel? hall;

  const ScheduleModel({
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
      id: _toInt(json['id']),
      classCategoryFeeId: _toInt(json['class_category_fee_id']),
      classSchedulePatternId: _toInt(
        json['class_schedule_pattern_id'],
      ),
      classDate: json['class_date']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      hall: json['hall'] is Map<String, dynamic>
          ? HallModel.fromJson(json['hall'])
          : null,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}