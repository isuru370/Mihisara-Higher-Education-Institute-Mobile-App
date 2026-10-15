class FeeOptionModel {
  final int id;
  final int classCategoryFeeId;
  final String label;
  final double fee;
  final bool isDefault;
  final bool isActive;

  FeeOptionModel({
    required this.id,
    required this.classCategoryFeeId,
    required this.label,
    required this.fee,
    required this.isDefault,
    required this.isActive,
  });

  factory FeeOptionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FeeOptionModel(
      id: _toInt(json['id']),

      classCategoryFeeId:
          _toInt(json['class_category_fee_id']),

      label:
          json['label']?.toString() ?? '',

      fee:
          _toDouble(json['fee']),

      isDefault:
          json['is_default'] == true,

      isActive:
          json['is_active'] == true,
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