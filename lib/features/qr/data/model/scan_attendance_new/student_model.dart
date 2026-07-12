class StudentModel {
  final int id;
  final String studentCode;
  final String initialName;
  final String guardianMobile;
  final String imgUrl;
  final GradeModel grade;

  StudentModel({
    required this.id,
    required this.studentCode,
    required this.initialName,
    required this.guardianMobile,
    required this.imgUrl,
    required this.grade,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      studentCode: json['student_code'],
      initialName: json['initial_name'],
      guardianMobile: json['guardian_mobile'],
      imgUrl: json['img_url'],
      grade: GradeModel.fromJson(json['grade']),
    );
  }
}

class GradeModel {
  final int id;
  final String gradeName;

  GradeModel({
    required this.id,
    required this.gradeName,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      id: json['id'],
      gradeName: json['grade_name'],
    );
  }
}