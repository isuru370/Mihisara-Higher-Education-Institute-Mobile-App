class ReadStudentClassesRequestModel {
  final String qrCode;

  ReadStudentClassesRequestModel({required this.qrCode});

  Map<String, dynamic> toQuery() {
    return { 'qr_code': qrCode};
  }
}
