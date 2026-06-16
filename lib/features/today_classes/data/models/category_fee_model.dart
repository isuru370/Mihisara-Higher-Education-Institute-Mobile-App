import 'category_model.dart';

class CategoryFeeModel {
  final int id;
  final int classCategoryId;
  final double fee;
  final CategoryModel category;

  CategoryFeeModel({
    required this.id,
    required this.classCategoryId,
    required this.fee,
    required this.category,
  });

  factory CategoryFeeModel.fromJson(Map<String, dynamic> json) {
    return CategoryFeeModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      classCategoryId: json['class_category_id'] is int
          ? json['class_category_id']
          : int.tryParse('${json['class_category_id']}') ?? 0,
      fee: double.tryParse(json['fee']?.toString() ?? '0') ?? 0,
      category: CategoryModel.fromJson(json['category'] as Map<String, dynamic>? ?? {}),
    );
  }
}