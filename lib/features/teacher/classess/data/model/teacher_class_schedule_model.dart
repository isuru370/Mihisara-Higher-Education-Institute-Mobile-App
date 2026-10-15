class TeacherClassScheduleModel {
  final int id;

  final int? studentClassId;
  final int? classCategoryFeeId;
  final int? classHallId;

  final String? classDate;
  final String? startTime;
  final String? endTime;
  final String? dayOfWeek;

  final String? status;
  final String? note;

  const TeacherClassScheduleModel({
    required this.id,
    this.studentClassId,
    this.classCategoryFeeId,
    this.classHallId,
    this.classDate,
    this.startTime,
    this.endTime,
    this.dayOfWeek,
    this.status,
    this.note,
  });

  factory TeacherClassScheduleModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherClassScheduleModel(
      id: json['id'] ?? 0,

      studentClassId: json['student_class_id'],

      classCategoryFeeId:
          json['class_category_fee_id'],

      classHallId: json['class_hall_id'],

      classDate: json['class_date']?.toString(),

      startTime: json['start_time']?.toString(),

      endTime: json['end_time']?.toString(),

      dayOfWeek: json['day_of_week']?.toString(),

      status: json['status']?.toString(),

      note: json['note']?.toString(),
    );
  }

  String get formattedDay {
    if (dayOfWeek == null || dayOfWeek!.isEmpty) {
      return '';
    }

    return dayOfWeek![0].toUpperCase() +
        dayOfWeek!.substring(1);
  }

  String get formattedTime {
    if (startTime == null || endTime == null) {
      return '';
    }

    String formatTime(String time) {
      final parts = time.split(':');

      if (parts.length < 2) {
        return time;
      }

      int hour = int.tryParse(parts[0]) ?? 0;
      final minute = parts[1];

      final period = hour >= 12 ? 'PM' : 'AM';

      if (hour == 0) {
        hour = 12;
      } else if (hour > 12) {
        hour -= 12;
      }

      return '$hour:$minute $period';
    }

    return '${formatTime(startTime!)} - '
        '${formatTime(endTime!)}';
  }
}