class AttendanceRequestModel {
  final int studentId;
  final int classScheduleId;
  final int studentClassId;
  final int classCategoryFeeId;
  final String markMethod;
  final bool markTute;
  final String? note;

  AttendanceRequestModel({
    required this.studentId,
    required this.classScheduleId,
    required this.studentClassId,
    required this.classCategoryFeeId,
    required this.markMethod,
    this.markTute = false,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'class_schedule_id': classScheduleId,
      'student_class_id': studentClassId,
      'class_category_fee_id': classCategoryFeeId,
      'mark_method': markMethod,
      'mark_tute': markTute,
      'note': note,
    };
  }
}
