class SummaryData {
  final int totalStudents;
  final int presentStudents;
  final int absentStudents;
  final int attendancePercentage;
  final int paidStudents;
  final int unpaidStudents;
  final int paymentPercentage;

  SummaryData({
    required this.totalStudents,
    required this.presentStudents,
    required this.absentStudents,
    required this.attendancePercentage,
    required this.paidStudents,
    required this.unpaidStudents,
    required this.paymentPercentage,
  });

  factory SummaryData.fromJson(Map<String, dynamic> json) {
    return SummaryData(
      totalStudents: json['total_students'] ?? 0,
      presentStudents: json['present_students'] ?? 0,
      absentStudents: json['absent_students'] ?? 0,
      attendancePercentage: json['attendance_percentage'] ?? 0,
      paidStudents: json['paid_students'] ?? 0,
      unpaidStudents: json['unpaid_students'] ?? 0,
      paymentPercentage: json['payment_percentage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_students': totalStudents,
      'present_students': presentStudents,
      'absent_students': absentStudents,
      'attendance_percentage': attendancePercentage,
      'paid_students': paidStudents,
      'unpaid_students': unpaidStudents,
      'payment_percentage': paymentPercentage,
    };
  }
}