import 'category_data.dart';

class ClassCategoryFeeData {
  final int id;
  final int classCategoryId;
  final CategoryData category;

  ClassCategoryFeeData({
    required this.id,
    required this.classCategoryId,
    required this.category,
  });

  factory ClassCategoryFeeData.fromJson(Map<String, dynamic> json) {
    return ClassCategoryFeeData(
      id: json['id'] ?? 0,
      classCategoryId: json['class_category_id'] ?? 0,
      category: CategoryData.fromJson(json['category'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_category_id': classCategoryId,
      'category': category.toJson(),
    };
  }
}