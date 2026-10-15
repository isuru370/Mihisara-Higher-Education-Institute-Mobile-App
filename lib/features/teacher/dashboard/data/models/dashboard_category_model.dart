class DashboardCategoryModel {
  final int id;
  final String name;
  final String code;

  const DashboardCategoryModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory DashboardCategoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DashboardCategoryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
    );
  }
}