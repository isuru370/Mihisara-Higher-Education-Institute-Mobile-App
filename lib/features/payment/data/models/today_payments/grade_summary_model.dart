class GradeSummaryModel {
  final String gradeName;

  GradeSummaryModel({
    required this.gradeName,
  });

  factory GradeSummaryModel.fromJson(Map<String, dynamic> json) {
    return GradeSummaryModel(
      gradeName: json['grade_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grade_name': gradeName,
    };
  }
}