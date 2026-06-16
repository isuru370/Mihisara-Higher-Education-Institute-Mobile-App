import 'category_model.dart';

class CategoryFeeModel {
  final int id;
  final int studentClassId;
  final int classCategoryId;
  final String fee;

  final CategoryModel category;

  const CategoryFeeModel({
    required this.id,
    required this.studentClassId,
    required this.classCategoryId,
    required this.fee,
    required this.category,
  });

  factory CategoryFeeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CategoryFeeModel(
      id: json['id'] ?? 0,
      studentClassId:
          json['student_class_id'] ?? 0,
      classCategoryId:
          json['class_category_id'] ?? 0,
      fee: json['fee'] ?? '',
      category: CategoryModel.fromJson(
        json['category'] ?? {},
      ),
    );
  }
}