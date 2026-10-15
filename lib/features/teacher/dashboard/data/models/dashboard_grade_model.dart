class DashboardGradeModel {
  final int id;
  final String name;

  const DashboardGradeModel({
    required this.id,
    required this.name,
  });

  factory DashboardGradeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DashboardGradeModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}