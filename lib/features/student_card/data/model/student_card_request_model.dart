class StudentCardRequestModel {
  final String qrCode;

  const StudentCardRequestModel({
    required this.qrCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'card_qr_code': qrCode,
    };
  }
}