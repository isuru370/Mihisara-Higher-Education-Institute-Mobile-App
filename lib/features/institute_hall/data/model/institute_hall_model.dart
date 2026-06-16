class InstituteHallModel {
  final int id;
  final String hallName;

  InstituteHallModel({
    required this.id,
    required this.hallName,
  });

  factory InstituteHallModel.fromJson(Map<String, dynamic> json) {
    return InstituteHallModel(
      id: json['id'],
      hallName: json['hall_name'],
    );
  }
}