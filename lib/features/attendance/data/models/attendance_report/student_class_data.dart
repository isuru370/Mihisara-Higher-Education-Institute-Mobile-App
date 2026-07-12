class StudentClassData {
  final int id;
  final String className;

  StudentClassData({
    required this.id,
    required this.className,
  });

  factory StudentClassData.fromJson(Map<String, dynamic> json) {
    return StudentClassData(
      id: json['id'] ?? 0,
      className: json['class_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_name': className,
    };
  }
}