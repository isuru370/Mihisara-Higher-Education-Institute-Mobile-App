class StudentClassModel {
  final int id;
  final String className;
  final String classType;
  final String medium;
  final GradeModel? grade;
  final SubjectModel? subject;
  final TeacherModel? teacher;

  const StudentClassModel({
    required this.id,
    required this.className,
    required this.classType,
    required this.medium,
    required this.grade,
    required this.subject,
    required this.teacher,
  });

  factory StudentClassModel.fromJson(Map<String, dynamic> json) {
    return StudentClassModel(
      id: _toInt(json['id']),
      className: json['class_name']?.toString() ?? '',
      classType: json['class_type']?.toString() ?? '',
      medium: json['medium']?.toString() ?? '',
      grade: json['grade'] is Map<String, dynamic>
          ? GradeModel.fromJson(json['grade'])
          : null,
      subject: json['subject'] is Map<String, dynamic>
          ? SubjectModel.fromJson(json['subject'])
          : null,
      teacher: json['teacher'] is Map<String, dynamic>
          ? TeacherModel.fromJson(json['teacher'])
          : null,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class GradeModel {
  final int id;
  final String gradeName;

  const GradeModel({
    required this.id,
    required this.gradeName,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      id: _toInt(json['id']),
      gradeName: json['grade_name']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class SubjectModel {
  final int id;
  final String subjectName;

  const SubjectModel({
    required this.id,
    required this.subjectName,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: _toInt(json['id']),
      subjectName: json['subject_name']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class TeacherModel {
  final int id;
  final String fullName;
  final String mobile;

  const TeacherModel({
    required this.id,
    required this.fullName,
    required this.mobile,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: _toInt(json['id']),
      fullName: json['full_name']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}