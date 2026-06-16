import 'today_payment_item_model.dart';

class TodayPaymentsResponseModel {
  final bool success;
  final String date;
  final int count;
  final List<TodayPaymentItemModel> data;

  TodayPaymentsResponseModel({
    required this.success,
    required this.date,
    required this.count,
    required this.data,
  });

  factory TodayPaymentsResponseModel.fromJson(Map<String, dynamic> json) {
    return TodayPaymentsResponseModel(
      success: json['success'] ?? false,
      date: json['date'] ?? '',
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => TodayPaymentItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'date': date,
      'count': count,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
