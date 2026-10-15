import 'fee_option_data_model.dart';

class ClassCategoryFeeDataModel {
  final int classCategoryFeeId;
  final int classCategoryId;
  final String categoryName;
  final bool isActive;
  final List<FeeOptionDataModel> feeOptions;

  ClassCategoryFeeDataModel({
    required this.classCategoryFeeId,
    required this.classCategoryId,
    required this.categoryName,
    required this.isActive,
    required this.feeOptions,
  });

  factory ClassCategoryFeeDataModel.fromJson(Map<String, dynamic> json) {
    return ClassCategoryFeeDataModel(
      classCategoryFeeId: _toInt(json['class_category_fee_id']),
      classCategoryId: _toInt(json['class_category_id']),
      categoryName: json['category_name']?.toString() ?? '',
      isActive: json['is_active'] == true,
      feeOptions: (json['fee_options'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(FeeOptionDataModel.fromJson)
          .toList(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    if (value is double) {
      return value.toInt();
    }
    return 0;
  }
}
