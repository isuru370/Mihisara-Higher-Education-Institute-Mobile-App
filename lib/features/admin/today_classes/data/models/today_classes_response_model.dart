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

  factory TodayClassesResponseModel.fromJson(Map<String, dynamic> json) {
    final responseData = json['data'] as Map<String, dynamic>? ?? {};

    return TodayClassesResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      date: responseData['date']?.toString() ?? '',
      count: _toInt(responseData['count']),
      data: (responseData['data'] as List<dynamic>? ?? [])
          .map(
            (item) =>
                TodayClassItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
