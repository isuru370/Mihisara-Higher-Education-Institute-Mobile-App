class ClassCategoryModel {
  final int id;
  final int fees;
  final String categoryName;

  ClassCategoryModel({
    required this.id,
    required this.fees,
    required this.categoryName,
  });

  factory ClassCategoryModel.fromJson(Map<String, dynamic> json) {
    return ClassCategoryModel(
      id: json['id'],
      fees: json['fees'],
      categoryName: json['class_category']['category_name'],
    );
  }
}
