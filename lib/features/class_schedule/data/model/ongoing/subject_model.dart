class SubjectModel {
  final int id;
  final String subjectName;

  SubjectModel({
    required this.id,
    required this.subjectName,
  });

  factory SubjectModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SubjectModel(
      id: json['id'] ?? 0,
      subjectName: json['subject_name'] ?? '',
    );
  }
}