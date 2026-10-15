class StudentCardModel {
  final int id;
  final String cardNumber;
  final String qrCode;
  final String status;
  final bool isCurrent;
  final String? issuedAt;
  final String? deactivatedAt;

  const StudentCardModel({
    required this.id,
    required this.cardNumber,
    required this.qrCode,
    required this.status,
    required this.isCurrent,
    this.issuedAt,
    this.deactivatedAt,
  });

  factory StudentCardModel.fromJson(Map<String, dynamic> json) {
    return StudentCardModel(
      id: json['id'] ?? 0,
      cardNumber: json['card_number'] ?? '',
      qrCode: json['qr_code'] ?? '',
      status: json['status'] ?? '',
      isCurrent: json['is_current'] ?? false,
      issuedAt: json['issued_at'],
      deactivatedAt: json['deactivated_at'],
    );
  }
}