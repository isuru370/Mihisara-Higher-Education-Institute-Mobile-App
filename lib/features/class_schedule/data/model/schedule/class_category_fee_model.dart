import 'category_model.dart';

class ClassCategoryFeeModel {
  final int id;
  final int studentClassId;
  final int classCategoryId;
  final String fee;
  final bool isActive;

  final CategoryModel category;

  const ClassCategoryFeeModel({
    required this.id,
    required this.studentClassId,
    required this.classCategoryId,
    required this.fee,
    required this.isActive,
    required this.category,
  });

  factory ClassCategoryFeeModel.fromJson(Map<String, dynamic> json) {
    return ClassCategoryFeeModel(
      id: json['id'] ?? 0,
      studentClassId: json['student_class_id'] ?? 0,
      classCategoryId: json['class_category_id'] ?? 0,
      fee: json['fee'] ?? '',
      isActive: json['is_active'] ?? false,
      category: CategoryModel.fromJson(json['category'] ?? {}),
    );
  }
}
