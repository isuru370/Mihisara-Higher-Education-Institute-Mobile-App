class FeeOptionModel {
  final int id;
  final String label;
  final double fee;
  final bool isDefault;
  final bool isActive;

  const FeeOptionModel({
    required this.id,
    required this.label,
    required this.fee,
    required this.isDefault,
    required this.isActive,
  });

  factory FeeOptionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FeeOptionModel(
      id: int.tryParse(
            json['id']?.toString() ?? '0',
          ) ??
          0,
      label: json['label']?.toString() ?? '',
      fee: double.tryParse(
            json['fee']?.toString() ?? '0',
          ) ??
          0.0,
      isDefault: json['is_default'] == true,
      isActive: json['is_active'] == true,
    );
  }
}