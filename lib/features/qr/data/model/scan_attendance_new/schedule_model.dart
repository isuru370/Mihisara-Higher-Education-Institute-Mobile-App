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

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'],
      classDate: json['class_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      hall: json['hall'],
      studentClass: ClassModel.fromJson(json['class']),
    );
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

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      className: json['class_name'],
      teacher: json['teacher'],
      subject: json['subject'],
      grade: json['grade'],
      category: json['category'],
    );
  }
}