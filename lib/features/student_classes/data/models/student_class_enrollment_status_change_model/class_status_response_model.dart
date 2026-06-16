class ClassStatusRecord {
  final int enrollmentId;
  final bool isActive;
  final String? leftAt;

  ClassStatusRecord({
    required this.enrollmentId,
    required this.isActive,
    this.leftAt,
  });

  factory ClassStatusRecord.fromJson(Map<String, dynamic> json) {
    return ClassStatusRecord(
      enrollmentId: _parseInt(json['enrollment_id']),
      isActive: _parseBool(json['is_active']),
      leftAt: json['left_at']?.toString(),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      return normalized == 'true' || normalized == '1';
    }
    return false;
  }
}

class ClassStatusResponseModel {
  final bool success;
  final String message;
  final ClassStatusRecord? data;

  ClassStatusResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ClassStatusResponseModel.fromJson(Map<String, dynamic> json) {
    return ClassStatusResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? ClassStatusRecord.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  bool get isSuccess => success;
}