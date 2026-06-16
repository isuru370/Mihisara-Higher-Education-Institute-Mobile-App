class TeacherSummaryModel {
  final int id;
  final String initials;

  TeacherSummaryModel({
    required this.id,
    required this.initials,
  });

  factory TeacherSummaryModel.fromJson(Map<String, dynamic> json) {
    return TeacherSummaryModel(
      id: json['id'] ?? 0,
      initials: json['initials'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'initials': initials,
    };
  }
}