class AttendanceInfo {
  final int attendanceId;
  final bool isPresent;
  final String? attendedAt;

  AttendanceInfo({
    required this.attendanceId,
    required this.isPresent,
    this.attendedAt,
  });

  factory AttendanceInfo.fromJson(Map<String, dynamic> json) {
    return AttendanceInfo(
      attendanceId: json['id'] ?? 0,
      isPresent: json['is_present'] ?? false,
      attendedAt: json['attended_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_present': isPresent,
      'attended_at': attendedAt,
    };
  }
}