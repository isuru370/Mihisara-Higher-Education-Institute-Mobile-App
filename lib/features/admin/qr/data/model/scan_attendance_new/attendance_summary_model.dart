class AttendanceSummaryModel {
  final String month;
  final int totalCount;
  final int presentCount;
  final int absentCount;
  final int attendancePercentage;

  AttendanceSummaryModel({
    required this.month,
    required this.totalCount,
    required this.presentCount,
    required this.absentCount,
    required this.attendancePercentage,
  });

  factory AttendanceSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceSummaryModel(
      month:
          json['month']?.toString() ?? '',

      totalCount:
          _toInt(json['total_count']),

      presentCount:
          _toInt(json['present_count']),

      absentCount:
          _toInt(json['absent_count']),

      attendancePercentage:
          _toInt(json['attendance_percentage']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is double) {
      return value.round();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}