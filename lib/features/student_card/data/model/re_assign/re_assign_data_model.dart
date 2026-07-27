class ReAssignDataModel {
  final int cardId;
  final String cardNumber;
  final String qrCode;
  final int studentId;
  final String status;

  const ReAssignDataModel({
    required this.cardId,
    required this.cardNumber,
    required this.qrCode,
    required this.studentId,
    required this.status,
  });

  factory ReAssignDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReAssignDataModel(
      cardId: json['card_id'] ?? 0,
      cardNumber: json['card_number'] ?? '',
      qrCode: json['qr_code'] ?? '',
      studentId: json['student_id'] ?? 0,
      status: json['status'] ?? '',
    );
  }
}