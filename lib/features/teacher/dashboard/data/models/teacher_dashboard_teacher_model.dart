class TeacherDashboardTeacherModel {
  final int id;
  final String customId;
  final String fullName;
  final String initials;
  final String? email;
  final String? mobile;
  final String? nic;
  final String? birthday;
  final String? gender;
  final bool isActive;

  const TeacherDashboardTeacherModel({
    required this.id,
    required this.customId,
    required this.fullName,
    required this.initials,
    this.email,
    this.mobile,
    this.nic,
    this.birthday,
    this.gender,
    required this.isActive,
  });

  factory TeacherDashboardTeacherModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherDashboardTeacherModel(
      id: (json['id'] as num?)?.toInt() ?? 0,

      customId: json['custom_id'] as String? ?? '',

      fullName: json['full_name'] as String? ?? '',

      initials: json['initials'] as String? ?? '',

      email: json['email'] as String?,

      mobile: json['mobile'] as String?,

      nic: json['nic'] as String?,

      birthday: json['birthday'] as String?,

      gender: json['gender'] as String?,

      isActive: json['is_active'] as bool? ?? false,
    );
  }
}