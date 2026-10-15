class TeacherTimetableSubjectModel {
  final int id;
  final String name;

  const TeacherTimetableSubjectModel({required this.id, required this.name});

  factory TeacherTimetableSubjectModel.fromJson(Map<String, dynamic> json) {
    return TeacherTimetableSubjectModel(
      id: _toInt(json['id']),

      name: json['name']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
