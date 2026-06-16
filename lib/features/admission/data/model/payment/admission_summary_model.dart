class AdmissionSummaryModel {
  final int paidCount;
  final int unpaidCount;
  final int totalCount;

  const AdmissionSummaryModel({
    required this.paidCount,
    required this.unpaidCount,
    required this.totalCount,
  });

  factory AdmissionSummaryModel.fromJson(Map<String, dynamic> json) {
    return AdmissionSummaryModel(
      paidCount: json['paid_count'] ?? 0,
      unpaidCount: json['unpaid_count'] ?? 0,
      totalCount: json['total_count'] ?? 0,
    );
  }
}
