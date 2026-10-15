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

  factory TuteModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TuteModel(
      month:
          json['month']?.toString() ?? '',

      isIssued:
          json['is_issued'] == true,

      issuedAt:
          json['issued_at']?.toString(),

      note:
          json['note']?.toString(),
    );
  }
}