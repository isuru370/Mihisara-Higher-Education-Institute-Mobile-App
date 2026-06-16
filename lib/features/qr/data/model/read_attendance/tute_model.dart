class TuteModel {
  final String month;

  final bool isIssued;

  final String? issuedAt;
  final String? note;

  TuteModel({
    required this.month,
    required this.isIssued,
    this.issuedAt,
    this.note,
  });

  factory TuteModel.fromJson(Map<String, dynamic>? json) {
    return TuteModel(
      month: json?['month'] as String? ?? '',
      isIssued: json?['is_issued'] as bool? ?? false,
      issuedAt: json?['issued_at'] as String?,
      note: json?['note'] as String?,
    );
  }
}
