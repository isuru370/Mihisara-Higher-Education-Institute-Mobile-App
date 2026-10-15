class FetchStudentTuteRequestModel {
  final int studentId;
  final int enrollmentId;

  FetchStudentTuteRequestModel({
    required this.studentId,
    required this.enrollmentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'enrollment_id': enrollmentId,
    };
  }
}