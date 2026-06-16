import 'today_class_item_model.dart';

class TodayClassesResponseModel {
  final bool success;
  final String date;
  final int count;
  final List<TodayClassItemModel> data;

  TodayClassesResponseModel({
    required this.success,
    required this.date,
    required this.count,
    required this.data,
  });

  factory TodayClassesResponseModel.fromJson(Map<String, dynamic> json) {
    return TodayClassesResponseModel(
      success: json['success'] == true,
      date: json['date']?.toString() ?? '',
      count: json['count'] is int ? json['count'] : int.tryParse('${json['count']}') ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => TodayClassItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}