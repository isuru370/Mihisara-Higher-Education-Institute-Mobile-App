class TeacherMiniModel {
  final int id;
  final String customId;
  final String initials;

  TeacherMiniModel({
    required this.id,
    required this.customId,
    required this.initials,
  });

  factory TeacherMiniModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherMiniModel(
      id: json['id'] ?? 0,
      customId: json['custom_id'] ?? '',
      initials: json['initials'] ?? '',
    );
  }
}