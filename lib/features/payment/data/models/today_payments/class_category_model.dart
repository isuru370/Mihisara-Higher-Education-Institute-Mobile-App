// category_model.dart
class ClassCategoryModel {
  final int? id;
  final String categoryName;
  final String? code;

  ClassCategoryModel({this.id, required this.categoryName, this.code});

  factory ClassCategoryModel.fromJson(Map<String, dynamic> json) {
    return ClassCategoryModel(
      id: json['id'] as int?,
      categoryName: json['category_name'] as String? ?? '',
      code: json['code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'category_name': categoryName, 'code': code};
  }
}
