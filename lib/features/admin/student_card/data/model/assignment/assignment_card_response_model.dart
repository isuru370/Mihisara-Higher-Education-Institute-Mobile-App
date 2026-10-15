class AssignmentCardResponseModel {
  final bool success;
  final String message;
  final AssignmentCardDataModel? data;

  const AssignmentCardResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory AssignmentCardResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AssignmentCardResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] == null
          ? null
          : AssignmentCardDataModel.fromJson(
              json['data'],
            ),
    );
  }
}

class AssignmentCardDataModel {
  final int id;
  final int studentId;
  final String cardNumber;
  final String qrCode;
  final String status;
  final bool isCurrent;
  final String? issuedAt;

  const AssignmentCardDataModel({
    required this.id,
    required this.studentId,
    required this.cardNumber,
    required this.qrCode,
    required this.status,
    required this.isCurrent,
    this.issuedAt,
  });

  factory AssignmentCardDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AssignmentCardDataModel(
      id: json['id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      cardNumber: json['card_number'] ?? '',
      qrCode: json['qr_code'] ?? '',
      status: json['status'] ?? '',
      isCurrent: json['is_current'] ?? false,
      issuedAt: json['issued_at']?.toString(),
    );
  }
}