class AttendanceScheduleRequestModel {
  final int studentClassId;
  final int classCategoryFeeId;

  const AttendanceScheduleRequestModel({
    required this.studentClassId,
    required this.classCategoryFeeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_class_id': studentClassId,
      'class_category_fee_id': classCategoryFeeId,
    };
  }
}