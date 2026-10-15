class TeacherClassSubjectModel {
  final int id;
  final String name;

  const TeacherClassSubjectModel({
    required this.id,
    required this.name,
  });

  factory TeacherClassSubjectModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherClassSubjectModel(
      id: json['id'] ?? 0,
      name: json['subject_name']?.toString() ??
          json['name']?.toString() ??
          '',
    );
  }
}