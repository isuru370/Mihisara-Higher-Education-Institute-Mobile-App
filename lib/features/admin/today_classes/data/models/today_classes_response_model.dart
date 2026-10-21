import 'today_class_item_model.dart';

class TodayClassesResponseModel {
  final bool success;
  final String message;
  final String date;
  final int count;
  final List<TodayClassItemModel> data;

  const TodayClassesResponseModel({
    required this.success,
    required this.message,
    required this.date,
    required this.count,
    required this.data,
  });

  /// Accepts both response shapes:
  ///  - flat:   { success, date, count, data: [ ...classes ] }   (current API)
  ///  - nested: { success, data: { date, count, data: [ ...classes ] } }
  factory TodayClassesResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    final Map<String, dynamic> meta =
        rawData is Map<String, dynamic> ? rawData : json;

    final rawItems = rawData is List ? rawData : meta['data'];

    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(TodayClassItemModel.fromJson)
            .toList()
        : <TodayClassItemModel>[];

    return TodayClassesResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      date: meta['date']?.toString() ?? '',
      count: meta['count'] != null ? _toInt(meta['count']) : items.length,
      data: items,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
