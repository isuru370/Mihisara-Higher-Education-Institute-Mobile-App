class UserTypeModel {
  final int id;
  final String name;
  final String code;
  final String? description;
  final bool isActive;

  const UserTypeModel({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.isActive,
  });

  factory UserTypeModel.fromJson(Map<String, dynamic> json) {
    return UserTypeModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: (json['name'] ?? '').toString(),
      code: (json['code'] ?? '').toString(),
      description: json['description']?.toString(),
      isActive: json['is_active'] == true ||
          json['is_active'].toString() == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'is_active': isActive,
    };
  }
}