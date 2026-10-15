class CurrentCardModel {
  final int id;
  final String cardNumber;
  final String qrCode;
  final String status;
  final bool isCurrent;
  final String? issuedAt;

  const CurrentCardModel({
    required this.id,
    required this.cardNumber,
    required this.qrCode,
    required this.status,
    required this.isCurrent,
    this.issuedAt,
  });

  factory CurrentCardModel.fromJson(Map<String, dynamic> json) {
    return CurrentCardModel(
      id: json['id'] ?? 0,
      cardNumber: json['card_number'] ?? '',
      qrCode: json['qr_code'] ?? '',
      status: json['status'] ?? '',
      isCurrent: json['is_current'] ?? false,
      issuedAt: json['issued_at'],
    );
  }
}