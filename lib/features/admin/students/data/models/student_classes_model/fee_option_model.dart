// ============================================================
// FEE OPTION
// ============================================================

class FeeOptionModel {
  final int id;
  final String label;
  final double fee;

  FeeOptionModel({
    required this.id,
    required this.label,
    required this.fee,
  });

  factory FeeOptionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FeeOptionModel(
      id: int.tryParse(
            json['id']?.toString() ?? '0',
          ) ??
          0,

      label:
          json['label']?.toString() ?? '',

      fee: double.tryParse(
            json['fee']?.toString() ?? '0',
          ) ??
          0.0,
    );
  }
}