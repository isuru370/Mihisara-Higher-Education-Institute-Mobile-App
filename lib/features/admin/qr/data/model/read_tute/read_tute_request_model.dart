class ReadTuteRequestModel {
  final String qrCode;

  ReadTuteRequestModel({
    required this.qrCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'qr_code': qrCode,
    };
  }
}