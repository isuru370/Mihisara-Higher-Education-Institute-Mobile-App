import 'category_fee_model.dart';

class ClassCategoryResponseModel {
  final bool success;
  final String message;
  final List<CategoryFeeModel> data;

  const ClassCategoryResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ClassCategoryResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClassCategoryResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(CategoryFeeModel.fromJson)
          .toList(),
    );
  }
}