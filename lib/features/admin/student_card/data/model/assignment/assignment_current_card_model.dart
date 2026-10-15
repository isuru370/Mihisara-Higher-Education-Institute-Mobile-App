class AssignmentCurrentCardModel {
  final int id;
  final String cardNumber;
  final String qrCode;
  final String status;

  const AssignmentCurrentCardModel({
    required this.id,
    required this.cardNumber,
    required this.qrCode,
    required this.status,
  });

  factory AssignmentCurrentCardModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AssignmentCurrentCardModel(
      id: json['id'] ?? 0,
      cardNumber: json['card_number'] ?? '',
      qrCode: json['qr_code'] ?? '',
      status: json['status'] ?? '',
    );
  }
}