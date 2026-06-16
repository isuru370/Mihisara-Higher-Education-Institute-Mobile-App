class StudentClassEnrollmentSummaryModel {
  final int id;

  StudentClassEnrollmentSummaryModel({
    required this.id,
  });

  factory StudentClassEnrollmentSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudentClassEnrollmentSummaryModel(
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}