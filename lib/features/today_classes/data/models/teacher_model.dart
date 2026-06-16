class TeacherModel {
  final int id;
  final String fullName;
  final String mobile;

  TeacherModel({
    required this.id,
    required this.fullName,
    required this.mobile,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      fullName: json['full_name']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
    );
  }
}