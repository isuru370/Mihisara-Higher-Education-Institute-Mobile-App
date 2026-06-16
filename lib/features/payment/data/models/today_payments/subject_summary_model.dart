class SubjectSummaryModel {
  final String subjectName;

  SubjectSummaryModel({
    required this.subjectName,
  });

  factory SubjectSummaryModel.fromJson(Map<String, dynamic> json) {
    return SubjectSummaryModel(
      subjectName: json['subject_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject_name': subjectName,
    };
  }
}