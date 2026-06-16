class ClassCategoryRequestModel {
  final int classId;

  const ClassCategoryRequestModel({
    required this.classId,
  });

  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
    };
  }
}