class StudentCardHistoryModel {
  final String? action;
  final String? reason;
  final String? remarks;
  final String? performedAt;
  final String? performedBy;

  final StudentCardInfoModel? oldCard;
  final StudentCardInfoModel? newCard;

  const StudentCardHistoryModel({
    this.action,
    this.reason,
    this.remarks,
    this.performedAt,
    this.performedBy,
    this.oldCard,
    this.newCard,
  });

  factory StudentCardHistoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudentCardHistoryModel(
      action: json['action']?.toString(),
      reason: json['reason']?.toString(),
      remarks: json['remarks']?.toString(),
      performedAt: json['performed_at']?.toString(),
      performedBy: json['performed_by']?.toString(),
      oldCard: json['old_card'] == null
          ? null
          : StudentCardInfoModel.fromJson(json['old_card']),
      newCard: json['new_card'] == null
          ? null
          : StudentCardInfoModel.fromJson(json['new_card']),
    );
  }
}

class StudentCardInfoModel {
  final int? id;
  final String? cardNumber;
  final String? qrCode;

  const StudentCardInfoModel({
    this.id,
    this.cardNumber,
    this.qrCode,
  });

  factory StudentCardInfoModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudentCardInfoModel(
      id: json['id'],
      cardNumber: json['card_number']?.toString(),
      qrCode: json['qr_code']?.toString(),
    );
  }
}