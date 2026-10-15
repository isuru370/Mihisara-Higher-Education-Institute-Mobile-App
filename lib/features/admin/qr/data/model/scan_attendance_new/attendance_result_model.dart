class AttendanceResultModel {
  final int id;
  final String status;
  final String markedAt;
  final String markMethod;
  final bool alreadyMarked;

  AttendanceResultModel({
    required this.id,
    required this.status,
    required this.markedAt,
    required this.markMethod,
    required this.alreadyMarked,
  });

  factory AttendanceResultModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceResultModel(
      id: _toInt(json['id']),
      status: json['status']?.toString() ?? '',
      markedAt: json['marked_at']?.toString() ?? '',
      markMethod: json['mark_method']?.toString() ?? '',
      alreadyMarked: json['already_marked'] == true,
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