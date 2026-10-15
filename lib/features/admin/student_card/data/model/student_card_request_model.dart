class StudentCardRequestModel {
  final String qrCode;

  const StudentCardRequestModel({
    required this.qrCode,
  });

  // Existing API (/qr-code)
  Map<String, dynamic> toJson() {
    return {
      'card_qr_code': qrCode,
    };
  }

  // Student Card Assignment API
  Map<String, dynamic> toAssignmentJson() {
    return {
      'code': qrCode,
    };
  }
}