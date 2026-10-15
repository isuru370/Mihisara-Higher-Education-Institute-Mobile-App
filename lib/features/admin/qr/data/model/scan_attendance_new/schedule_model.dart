class ScheduleModel {
  final int id;
  final String classDate;
  final String startTime;
  final String endTime;
  final String hall;
  final ClassModel studentClass;

  ScheduleModel({
    required this.id,
    required this.classDate,
    required this.startTime,
    required this.endTime,
    required this.hall,
    required this.studentClass,
  });

  factory ScheduleModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ScheduleModel(
      id: _toInt(json['id']),

      classDate:
          json['class_date']?.toString() ?? '',

      startTime:
          json['start_time']?.toString() ?? '',

      endTime:
          json['end_time']?.toString() ?? '',

      hall:
          json['hall']?.toString() ?? '',

      studentClass:
          json['class'] is Map<String, dynamic>
              ? ClassModel.fromJson(
                  json['class'] as Map<String, dynamic>,
                )
              : ClassModel.empty(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}

class ClassModel {
  final int id;
  final String className;
  final String teacher;
  final String subject;
  final String grade;
  final String category;

  ClassModel({
    required this.id,
    required this.className,
    required this.teacher,
    required this.subject,
    required this.grade,
    required this.category,
  });

  factory ClassModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClassModel(
      id: _toInt(json['id']),

      className:
          json['class_name']?.toString() ?? '',

      teacher:
          json['teacher']?.toString() ?? '',

      subject:
          json['subject']?.toString() ?? '',

      grade:
          json['grade']?.toString() ?? '',

      category:
          json['category']?.toString() ?? '',
    );
  }

  factory ClassModel.empty() {
    return ClassModel(
      id: 0,
      className: '',
      teacher: '',
      subject: '',
      grade: '',
      category: '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}