class ScanAttendanceRequestModel {
  final String code;
  final String markMethod;

  ScanAttendanceRequestModel({
    required this.code,
    required this.markMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'mark_method': markMethod,
    };
  }
}