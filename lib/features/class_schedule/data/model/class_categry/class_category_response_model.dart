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
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map(
            (e) => CategoryFeeModel.fromJson(e),
          )
          .toList(),
    );
  }
}