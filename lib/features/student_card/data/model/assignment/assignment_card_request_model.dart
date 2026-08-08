class AssignmentCardRequestModel {
  final int studentId;
  final String cardQrCode;

  const AssignmentCardRequestModel({
    required this.studentId,
    required this.cardQrCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'card_qr_code': cardQrCode,
    };
  }
}