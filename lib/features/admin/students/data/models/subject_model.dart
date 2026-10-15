class SubjectModel {
  final int? subjectId; // nullable
  final String subjectName;

  SubjectModel({this.subjectId, required this.subjectName});

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      subjectId: json['id'] != null ? json['id'] as int : null, // safe
      subjectName: json['subject_name'] ?? 'N/A',
    );
  }
}
