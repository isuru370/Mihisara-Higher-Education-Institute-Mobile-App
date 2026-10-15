class DashboardSubjectModel {
  final int id;
  final String name;

  const DashboardSubjectModel({
    required this.id,
    required this.name,
  });

  factory DashboardSubjectModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DashboardSubjectModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}