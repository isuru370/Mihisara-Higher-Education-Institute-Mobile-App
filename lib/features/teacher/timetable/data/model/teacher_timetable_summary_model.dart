class TeacherTimetableSummaryModel {
  final int totalClasses;
  final int scheduled;
  final int ongoing;
  final int completed;
  final int cancelled;
  final int totalStudents;

  const TeacherTimetableSummaryModel({
    required this.totalClasses,
    required this.scheduled,
    required this.ongoing,
    required this.completed,
    required this.cancelled,
    required this.totalStudents,
  });

  factory TeacherTimetableSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherTimetableSummaryModel(
      totalClasses: _toInt(json['total_classes']),
      scheduled: _toInt(json['scheduled']),
      ongoing: _toInt(json['ongoing']),
      completed: _toInt(json['completed']),
      cancelled: _toInt(json['cancelled']),
      totalStudents: _toInt(json['total_students']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}