class TeacherStudentModel {
  final int id;
  final String? customId;
  final String? fullName;
  final String? mobile;
  final String? imgUrl;
  final bool isActive;

  const TeacherStudentModel({
    required this.id,
    this.customId,
    this.fullName,
    this.mobile,
    this.imgUrl,
    required this.isActive,
  });

  factory TeacherStudentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherStudentModel(
      id: json['id'] ?? 0,
      customId: json['custom_id'],
      fullName: json['full_name'],
      mobile: json['mobile'],
      imgUrl: json['img_url'],
      isActive: json['is_active'] ?? false,
    );
  }
}
