class FeeOptionDataModel {
  final int id;
  final String label;
  final double fee;
  final bool isDefault;
  final bool isActive;

  FeeOptionDataModel({
    required this.id,
    required this.label,
    required this.fee,
    required this.isDefault,
    required this.isActive,
  });

  factory FeeOptionDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FeeOptionDataModel(
      id: _toInt(json['id']),
      label: json['label']?.toString() ?? '',
      fee: _toDouble(json['fee']),
      isDefault: json['is_default'] == true,
      isActive: json['is_active'] == true,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
}