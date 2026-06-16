class UserTypeModel {
  final int id;
  final String type;

  UserTypeModel({
    required this.id,
    required this.type,
  });

  factory UserTypeModel.fromJson(Map<String, dynamic> json) {
    return UserTypeModel(
      id: json['id'],
      type: json['type'],
    );
  }
}
