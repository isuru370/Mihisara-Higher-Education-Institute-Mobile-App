class CategoryModel {
  final int id;
  final String categoryName;

  CategoryModel({
    required this.id,
    required this.categoryName,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      categoryName: json['category_name']?.toString() ?? '',
    );
  }
}