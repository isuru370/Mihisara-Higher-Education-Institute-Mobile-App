class StudentClassModel {
  final int id;
  final String className;

  const StudentClassModel({
    required this.id,
    required this.className,
  });

  factory StudentClassModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudentClassModel(
      id: json['id'] ?? 0,
      className:
          json['class_name'] ?? '',
    );
  }
}