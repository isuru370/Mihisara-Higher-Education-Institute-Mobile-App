class ReadAttendanceRequestModel {
  final String qrCode;
  final int studentClassId;
  final int classCategoryFeeId;

  ReadAttendanceRequestModel({
    required this.qrCode,
    required this.studentClassId,
    required this.classCategoryFeeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'qr_code': qrCode,
      'student_class_id': studentClassId,
      'class_category_fee_id': classCategoryFeeId,
    };
  }
}