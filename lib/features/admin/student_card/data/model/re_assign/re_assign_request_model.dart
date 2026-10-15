class ReAssignRequestModel {
  final String oldQrCode;
  final String newQrCode;
  final String reason;
  final String? remarks;

  const ReAssignRequestModel({
    required this.oldQrCode,
    required this.newQrCode,
    required this.reason,
    this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'old_qr_code': oldQrCode,
      'new_qr_code': newQrCode,
      'reason': reason,
      'remarks': remarks,
    };
  }
}