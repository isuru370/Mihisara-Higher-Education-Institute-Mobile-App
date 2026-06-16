class AttendanceStudentModel {
  final int studentId;
  final String customId;
  final String fname;
  final String lname;
  final String guardianMobile;
  final String attendanceStatus;
  final String? status;
  final int? attendanceId;
  final String attendanceDate;
  final bool isPresent;

  AttendanceStudentModel({
    required this.studentId,
    required this.customId,
    required this.fname,
    required this.lname,
    required this.guardianMobile,
    required this.attendanceStatus,
    this.status,
    this.attendanceId,
    required this.attendanceDate,
    required this.isPresent,
  });

  factory AttendanceStudentModel.fromJson(
      Map<String, dynamic> json) {
    return AttendanceStudentModel(
      studentId: json['student_id'],
      customId: json['custom_id'],
      fname: json['fname'],
      lname: json['lname'],
      guardianMobile: json['guardian_mobile'],
      attendanceStatus: json['attendance_status'],
      status: json['status']?.toString(),
      attendanceId: json['attendance_id'],
      attendanceDate: json['attendance_date'],
      isPresent: json['is_present'] ?? false,
    );
  }
}
