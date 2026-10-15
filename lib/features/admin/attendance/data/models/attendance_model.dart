class AttendanceModel {
  final int id;
  final String? localUuid;
  final int studentId;
  final int classScheduleId;
  final int? studentClassEnrollmentId;
  final DateTime attendedAt;
  final String markMethod;
  final int? markedBy;
  final bool isSynced;
  final String? note;
  final bool tute;
  AttendanceModel({
    required this.id,
    this.localUuid,
    required this.studentId,
    required this.classScheduleId,
    this.studentClassEnrollmentId,
    required this.attendedAt,
    required this.markMethod,
    this.markedBy,
    required this.isSynced,
    this.note,
    this.tute = false,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] ?? 0,
      localUuid: json['local_uuid'],
      studentId: json['student_id'] ?? 0,
      classScheduleId: json['class_schedule_id'] ?? 0,
      studentClassEnrollmentId:
          json['student_class_enrollment_id'],
      attendedAt: json['attended_at'] != null
          ? DateTime.parse(json['attended_at'])
          : DateTime.now(),
      markMethod: json['mark_method'] ?? 'qr_mobile',
      markedBy: json['marked_by'],
      isSynced: json['is_synced'] ?? true,
      note: json['note'],
      tute: json['tute_issued'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'local_uuid': localUuid,
      'student_id': studentId,
      'class_schedule_id': classScheduleId,
      'student_class_enrollment_id':
          studentClassEnrollmentId,
      'attended_at': attendedAt.toIso8601String(),
      'mark_method': markMethod,
      'marked_by': markedBy,
      'is_synced': isSynced,
      'note': note,
      'tute_issued': tute,
    };
  }

  AttendanceModel copyWith({
    int? id,
    String? localUuid,
    int? studentId,
    int? classScheduleId,
    int? studentClassEnrollmentId,
    DateTime? attendedAt,
    String? markMethod,
    int? markedBy,
    bool? isSynced,
    String? note,
    bool? tute,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      localUuid: localUuid ?? this.localUuid,
      studentId: studentId ?? this.studentId,
      classScheduleId:
          classScheduleId ?? this.classScheduleId,
      studentClassEnrollmentId:
          studentClassEnrollmentId ??
              this.studentClassEnrollmentId,
      attendedAt: attendedAt ?? this.attendedAt,
      markMethod: markMethod ?? this.markMethod,
      markedBy: markedBy ?? this.markedBy,
      isSynced: isSynced ?? this.isSynced,
      note: note ?? this.note,
      tute: tute ?? this.tute,
    );
  }
}