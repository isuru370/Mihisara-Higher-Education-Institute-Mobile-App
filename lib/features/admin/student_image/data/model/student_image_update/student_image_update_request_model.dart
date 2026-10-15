class StudentImageUpdateResponseModel {
  final bool success;
  final String message;
  final StudentImageUpdateDataModel? data;

  StudentImageUpdateResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory StudentImageUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return StudentImageUpdateResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? StudentImageUpdateDataModel.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class StudentImageUpdateDataModel {
  final int studentId;
  final String customId;
  final String initialName;
  final String imgUrl;
  final DateTime? updatedAt;
  final String quickImageId;
  final bool quickPhotoActive;

  StudentImageUpdateDataModel({
    required this.studentId,
    required this.customId,
    required this.initialName,
    required this.imgUrl,
    required this.updatedAt,
    required this.quickImageId,
    required this.quickPhotoActive,
  });

  factory StudentImageUpdateDataModel.fromJson(Map<String, dynamic> json) {
    return StudentImageUpdateDataModel(
      studentId: json['student_id'] ?? 0,
      customId: json['custom_id'] ?? '',
      initialName: json['initial_name'] ?? '',
      imgUrl: json['img_url'] ?? '',
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      quickImageId: json['quick_image_id'] ?? '',
      quickPhotoActive: json['quick_photo_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'custom_id': customId,
      'initial_name': initialName,
      'img_url': imgUrl,
      'updated_at': updatedAt?.toIso8601String(),
      'quick_image_id': quickImageId,
      'quick_photo_active': quickPhotoActive,
    };
  }
}
