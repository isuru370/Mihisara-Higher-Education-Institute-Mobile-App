class ScanPaymentFeeOptionModel {
  final int? id;
  final int? classCategoryFeeId;
  final String label;
  final double fee;
  final bool isDefault;
  final bool isActive;
  final String? note;

  const ScanPaymentFeeOptionModel({
    this.id,
    this.classCategoryFeeId,
    this.label = '',
    this.fee = 0,
    this.isDefault = false,
    this.isActive = false,
    this.note,
  });

  factory ScanPaymentFeeOptionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ScanPaymentFeeOptionModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(
              json['id']?.toString() ?? '',
            ),

      classCategoryFeeId:
          json['class_category_fee_id'] is int
              ? json['class_category_fee_id']
              : int.tryParse(
                  json['class_category_fee_id']
                          ?.toString() ??
                      '',
                ),

      label: json['label']?.toString() ?? '',

      fee: _toDouble(json['fee']),

      isDefault: json['is_default'] == true ||
          json['is_default'] == 1,

      isActive: json['is_active'] == true ||
          json['is_active'] == 1,

      note: json['note']?.toString(),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value.toString(),
        ) ??
        0;
  }
}