class CategoryModel {
  final int id;
  final String categoryName;

  const CategoryModel({
    required this.id,
    required this.categoryName,
  });

  factory CategoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CategoryModel(
      id: json['id'] ?? 0,
      categoryName:
          json['category_name'] ?? '',
    );
  }
}