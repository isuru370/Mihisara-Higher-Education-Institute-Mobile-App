import 'schedule_model.dart';
import 'student_model.dart';

/// Returned by `/new-attendance/scan` when more than one class is open for
/// the student at the scan time. Attendance is NOT marked yet; the staff
/// member picks one option and the app scans again with its
/// `class_schedule_id`.
class ClassSelectionModel {
  final StudentModel student;
  final List<ClassOptionModel> options;

  ClassSelectionModel({
    required this.student,
    required this.options,
  });

  factory ClassSelectionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];

    return ClassSelectionModel(
      student: StudentModel.fromJson(
        json['student'] as Map<String, dynamic>,
      ),
      options: rawOptions is List
          ? rawOptions
              .whereType<Map<String, dynamic>>()
              .map(ClassOptionModel.fromJson)
              .toList()
          : <ClassOptionModel>[],
    );
  }
}

class ClassOptionModel {
  final int classScheduleId;
  final String classDate;
  final String startTime;
  final String endTime;
  final String hall;
  final ClassModel studentClass;
  final bool alreadyMarked;

  ClassOptionModel({
    required this.classScheduleId,
    required this.classDate,
    required this.startTime,
    required this.endTime,
    required this.hall,
    required this.studentClass,
    required this.alreadyMarked,
  });

  factory ClassOptionModel.fromJson(Map<String, dynamic> json) {
    return ClassOptionModel(
      classScheduleId: _toInt(json['class_schedule_id'] ?? json['id']),
      classDate: json['class_date']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      hall: json['hall']?.toString() ?? '',
      studentClass: json['class'] is Map<String, dynamic>
          ? ClassModel.fromJson(json['class'] as Map<String, dynamic>)
          : ClassModel.empty(),
      alreadyMarked: json['already_marked'] == true,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
