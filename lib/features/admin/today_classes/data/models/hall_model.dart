class HallModel {
  final int id;
  final String hallName;
  final String code;

  HallModel({
    required this.id,
    required this.hallName,
    required this.code,
  });

  factory HallModel.fromJson(Map<String, dynamic> json) {
    return HallModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      hallName: json['hall_name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
    );
  }
}