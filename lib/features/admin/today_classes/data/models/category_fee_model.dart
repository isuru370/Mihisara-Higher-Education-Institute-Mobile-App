import 'category_model.dart';
import 'fee_option_model.dart';

class CategoryFeeModel {
  final int id;
  final int classCategoryId;
  final CategoryModel? category;
  final List<FeeOptionModel> feeOptions;

  const CategoryFeeModel({
    required this.id,
    required this.classCategoryId,
    required this.category,
    required this.feeOptions,
  });

  factory CategoryFeeModel.fromJson(Map<String, dynamic> json) {
    return CategoryFeeModel(
      id: _toInt(json['id']),
      classCategoryId: _toInt(json['class_category_id']),
      category: json['category'] is Map<String, dynamic>
          ? CategoryModel.fromJson(json['category'])
          : null,
      feeOptions: (json['fee_options'] as List<dynamic>? ?? [])
          .map(
            (e) => FeeOptionModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

