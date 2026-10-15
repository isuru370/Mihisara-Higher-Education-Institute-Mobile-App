import 'category_model.dart';
import 'fee_option_model.dart';

class CategoryFeeModel {
  final int id;
  final int studentClassId;
  final int classCategoryId;
  final CategoryModel? category;
  final List<FeeOptionModel> feeOptions;

  const CategoryFeeModel({
    required this.id,
    required this.studentClassId,
    required this.classCategoryId,
    required this.category,
    required this.feeOptions,
  });

  factory CategoryFeeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CategoryFeeModel(
      id: int.tryParse(
            json['id']?.toString() ?? '0',
          ) ??
          0,
      studentClassId: int.tryParse(
            json['student_class_id']?.toString() ?? '0',
          ) ??
          0,
      classCategoryId: int.tryParse(
            json['class_category_id']?.toString() ?? '0',
          ) ??
          0,
      category: json['category'] is Map<String, dynamic>
          ? CategoryModel.fromJson(
              json['category'] as Map<String, dynamic>,
            )
          : null,
      feeOptions: (json['fee_options'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(FeeOptionModel.fromJson)
          .toList(),
    );
  }
}