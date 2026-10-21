import 'today_payment_item_model.dart';
import 'today_payment_summary_model.dart';

class TodayPaymentsResponseModel {
  final bool success;
  final List<TodayPaymentItemModel> data;
  final TodayPaymentSummaryModel summary;

  final String date;
  final String? search;

  final int total;

  const TodayPaymentsResponseModel({
    required this.success,
    required this.data,
    required this.summary,
    required this.date,
    required this.search,
    required this.total,
  });

  factory TodayPaymentsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final filters =
        json['filters'] as Map<String, dynamic>? ?? {};

    final meta =
        json['meta'] as Map<String, dynamic>? ?? {};

    final items = (json['data'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(TodayPaymentItemModel.fromJson)
        .toList();

    // The server sends { success, date, count, data } with no summary, so
    // the totals were always 0. Work them out from the rows when missing.
    final summaryJson = json['summary'];

    final summary = summaryJson is Map<String, dynamic>
        ? TodayPaymentSummaryModel.fromJson(summaryJson)
        : TodayPaymentSummaryModel(
            paymentCount: items.length,
            totalAmount: items.fold(0.0, (sum, item) => sum + item.amount),
            totalDiscount: items.fold(
              0.0,
              (sum, item) => sum + item.discountAmount,
            ),
          );

    return TodayPaymentsResponseModel(
      success: json['success'] == true,

      data: items,

      summary: summary,

      date: (filters['date'] ?? json['date'])?.toString() ?? '',

      search: filters['search']?.toString(),

      total: int.tryParse(
            (meta['total'] ?? json['count'])?.toString() ?? '',
          ) ??
          items.length,
    );
  }
}