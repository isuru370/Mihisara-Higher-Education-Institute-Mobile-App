class AttendanceResponseModel {
  final String status;
  final String message;
  final AttendanceResponseData? data;

  AttendanceResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory AttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    return AttendanceResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null
          ? AttendanceResponseData.fromJson(
              Map<String, dynamic>.from(json['data']),
            )
          : null,
    );
  }
}

class AttendanceResponseData {
  final AttendanceRecord? attendance;
  final StudentSummary? student;
  final String enrollmentStatus;
  final bool smsQueued;
  final bool tuteIssued;

  AttendanceResponseData({
    this.attendance,
    this.student,
    required this.enrollmentStatus,
    required this.smsQueued,
    required this.tuteIssued,
  });

  factory AttendanceResponseData.fromJson(Map<String, dynamic> json) {
    return AttendanceResponseData(
      attendance: json['attendance'] != null
          ? AttendanceRecord.fromJson(
              Map<String, dynamic>.from(json['attendance']),
            )
          : null,
      student: json['student'] != null
          ? StudentSummary.fromJson(
              Map<String, dynamic>.from(json['student']),
            )
          : null,
      enrollmentStatus: json['enrollment_status'] ?? '',
      smsQueued: json['sms_queued'] ?? false,
      tuteIssued: json['tute_issued'] ?? false,
    );
  }
}

class AttendanceRecord {
  final int id;
  final int studentId;
  final int classScheduleId;
  final int? studentClassEnrollmentId;
  final String? attendedAt;
  final String? markMethod;

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.classScheduleId,
    this.studentClassEnrollmentId,
    this.attendedAt,
    this.markMethod,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      classScheduleId: json['class_schedule_id'] ?? 0,
      studentClassEnrollmentId: json['student_class_enrollment_id'],
      attendedAt: json['attended_at'],
      markMethod: json['mark_method'],
    );
  }
}

class StudentSummary {
  final int id;
  final String? customId;
  final String? initialName;

  StudentSummary({
    required this.id,
    this.customId,
    this.initialName,
  });

  factory StudentSummary.fromJson(Map<String, dynamic> json) {
    return StudentSummary(
      id: json['id'] ?? 0,
      customId: json['custom_id'],
      initialName: json['initial_name'],
    );
  }
}