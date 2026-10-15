class TeacherTimetableGradeModel {
  final int id;
  final String name;

  const TeacherTimetableGradeModel({
    required this.id,
    required this.name,
  });

  factory TeacherTimetableGradeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherTimetableGradeModel(
      id: _toInt(json['id']),

      name: json['name']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}