class ScanPaymentRequestModel {
  final String code;

  const ScanPaymentRequestModel({
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
    };
  }

  factory ScanPaymentRequestModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ScanPaymentRequestModel(
      code: json['code']?.toString() ?? '',
    );
  }
}