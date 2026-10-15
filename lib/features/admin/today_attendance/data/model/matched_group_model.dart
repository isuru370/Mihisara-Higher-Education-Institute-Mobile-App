class MatchedGroupModel {
  final int classCategoryHasStudentClassId;
  final String categoryName;

  MatchedGroupModel({
    required this.classCategoryHasStudentClassId,
    required this.categoryName,
  });

  factory MatchedGroupModel.fromJson(Map<String, dynamic> json) {
    return MatchedGroupModel(
      classCategoryHasStudentClassId:
          json['class_category_has_student_class_id'],
      categoryName: json['category_name'],
    );
  }
}
