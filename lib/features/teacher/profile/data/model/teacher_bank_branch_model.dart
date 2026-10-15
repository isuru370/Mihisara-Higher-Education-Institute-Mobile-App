class TeacherBankBranchModel {
  final int id;
  final String? name;
  final String? code;

  const TeacherBankBranchModel({
    required this.id,
    this.name,
    this.code,
  });

  factory TeacherBankBranchModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherBankBranchModel(
      id: json['id'] ?? 0,
      name: json['name'],
      code: json['code'],
    );
  }
}