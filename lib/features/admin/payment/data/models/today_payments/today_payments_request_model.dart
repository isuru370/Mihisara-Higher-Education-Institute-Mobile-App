import 'package:intl/intl.dart';

class TodayPaymentsRequestModel {
  final DateTime date;

  TodayPaymentsRequestModel({
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': DateFormat('yyyy-MM-dd').format(date),
    };
  }
}