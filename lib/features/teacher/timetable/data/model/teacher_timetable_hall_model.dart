class TeacherTimetableHallModel {
  final int id;
  final String name;
  final String? type;
  final double price;

  const TeacherTimetableHallModel({
    required this.id,
    required this.name,
    this.type,
    required this.price,
  });

  factory TeacherTimetableHallModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherTimetableHallModel(
      id: _toInt(json['id']),

      name: json['name']?.toString() ?? '',

      type: json['type']?.toString(),

      price: _toDouble(json['price']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0.0;
  }
}