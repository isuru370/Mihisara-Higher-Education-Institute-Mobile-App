class UpdateClassScheduleRequestModel {
  final int scheduleId;
  final int classCategoryFeeId;
  final int classHallId;
  final String classDate;
  final String startTime;
  final String endTime;
  final String dayOfWeek;
  final String? note;

  const UpdateClassScheduleRequestModel({
    required this.scheduleId,
    required this.classCategoryFeeId,
    required this.classHallId,
    required this.classDate,
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'schedule_id': scheduleId,
      'class_category_fee_id': classCategoryFeeId,
      'class_hall_id': classHallId,
      'class_date': classDate,
      'start_time': startTime,
      'end_time': endTime,
      'day_of_week': dayOfWeek,
      'note': note,
    };
  }
}