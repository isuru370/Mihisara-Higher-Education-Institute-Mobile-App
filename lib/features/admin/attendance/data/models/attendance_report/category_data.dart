class CategoryData {
  final int id;
  final String categoryName;

  CategoryData({
    required this.id,
    required this.categoryName,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['id'] ?? 0,
      categoryName: json['category_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_name': categoryName,
    };
  }
}