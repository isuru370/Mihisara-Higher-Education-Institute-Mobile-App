class ScanAttendanceRequestModel {
  final String qrCode;

  ScanAttendanceRequestModel({required this.qrCode});

  Map<String, dynamic> toJson() {
    return {'qr_code': qrCode};
  }
}
