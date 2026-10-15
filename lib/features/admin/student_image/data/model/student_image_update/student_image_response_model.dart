class StudentImageUpdateRequestModel {
  final int studentId;
  final String quickImageId;

  StudentImageUpdateRequestModel({
    required this.studentId,
    required this.quickImageId,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'quick_image_id': quickImageId,
    };
  }
}