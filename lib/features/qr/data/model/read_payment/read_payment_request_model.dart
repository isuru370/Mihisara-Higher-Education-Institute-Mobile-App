class ReadPaymentRequestModel {
  final String qrCode;

  ReadPaymentRequestModel({required this.qrCode});

  Map<String, dynamic> toQuery() {
    return {
      'qr_code': qrCode,
    };
  }
}
