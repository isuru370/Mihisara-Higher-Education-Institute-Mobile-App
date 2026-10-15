class DashboardHallModel {
  final int id;
  final String name;

  const DashboardHallModel({
    required this.id,
    required this.name,
  });

  factory DashboardHallModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DashboardHallModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
    );
  }
}