class PortalLoginModel {
  final int id;
  final int studentId;
  final String username;
  final bool isVerify;
  final bool isActive;

  PortalLoginModel({
    required this.id,
    required this.studentId,
    required this.username,
    required this.isVerify,
    required this.isActive,
  });

  factory PortalLoginModel.fromJson(Map<String, dynamic> json) {
    return PortalLoginModel(
      id: json['id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      username: json['username'] ?? '',
      isVerify: json['is_verify'] ?? false,
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'username': username,
      'is_verify': isVerify,
      'is_active': isActive,
    };
  }
}
