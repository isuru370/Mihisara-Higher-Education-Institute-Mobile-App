import 'teacher_timetable_subject_model.dart';
import 'teacher_timetable_grade_model.dart';
import 'teacher_timetable_category_model.dart';
import 'teacher_timetable_category_fee_model.dart';
import 'teacher_timetable_hall_model.dart';

class TeacherTimetableClassModel {
  final int id;
  final int classId;

  final String title;
  final String subtitle;
  final String className;

  final String? classType;
  final String? medium;

  final TeacherTimetableSubjectModel? subject;
  final TeacherTimetableGradeModel? grade;
  final TeacherTimetableCategoryModel? category;
  final TeacherTimetableCategoryFeeModel? categoryFee;
  final TeacherTimetableHallModel? hall;

  final String? date;
  final String? startTime;
  final String? endTime;

  final int students;

  /// Actual database status.
  ///
  /// scheduled
  /// ongoing
  /// completed
  /// cancelled
  final String? status;

  final String? cancelReason;
  final int? cancelledBy;
  final String? cancelledAt;
  final String? note;

  const TeacherTimetableClassModel({
    required this.id,
    required this.classId,
    required this.title,
    required this.subtitle,
    required this.className,
    this.classType,
    this.medium,
    this.subject,
    this.grade,
    this.category,
    this.categoryFee,
    this.hall,
    this.date,
    this.startTime,
    this.endTime,
    required this.students,
    this.status,
    this.cancelReason,
    this.cancelledBy,
    this.cancelledAt,
    this.note,
  });

  factory TeacherTimetableClassModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherTimetableClassModel(
      id: _toInt(json['id']),

      classId: _toInt(json['class_id']),

      title: json['title']?.toString() ?? '',

      subtitle: json['subtitle']?.toString() ?? '',

      className: json['class_name']?.toString() ?? '',

      classType: json['class_type']?.toString(),

      medium: json['medium']?.toString(),

      subject: json['subject'] is Map<String, dynamic>
          ? TeacherTimetableSubjectModel.fromJson(
              json['subject'] as Map<String, dynamic>,
            )
          : null,

      grade: json['grade'] is Map<String, dynamic>
          ? TeacherTimetableGradeModel.fromJson(
              json['grade'] as Map<String, dynamic>,
            )
          : null,

      category: json['category'] is Map<String, dynamic>
          ? TeacherTimetableCategoryModel.fromJson(
              json['category'] as Map<String, dynamic>,
            )
          : null,

      categoryFee: json['category_fee'] is Map<String, dynamic>
          ? TeacherTimetableCategoryFeeModel.fromJson(
              json['category_fee'] as Map<String, dynamic>,
            )
          : null,

      hall: json['hall'] is Map<String, dynamic>
          ? TeacherTimetableHallModel.fromJson(
              json['hall'] as Map<String, dynamic>,
            )
          : null,

      date: json['date']?.toString(),

      startTime: json['start_time']?.toString(),

      endTime: json['end_time']?.toString(),

      students: _toInt(json['students']),

      // Actual DB status
      status: json['status']?.toString(),

      cancelReason: json['cancel_reason']?.toString(),

      cancelledBy: json['cancelled_by'] == null
          ? null
          : _toInt(json['cancelled_by']),

      cancelledAt: json['cancelled_at']?.toString(),

      note: json['note']?.toString(),
    );
  }

  // ============================================================
  // DB STATUS HELPERS
  // ============================================================

  bool get isScheduled {
    return status?.toLowerCase() == 'scheduled';
  }

  bool get isOngoing {
    return status?.toLowerCase() == 'ongoing';
  }

  bool get isCompleted {
    return status?.toLowerCase() == 'completed';
  }

  bool get isCancelled {
    return status?.toLowerCase() == 'cancelled';
  }

  // ============================================================
  // DISPLAY STATUS
  // ============================================================

  String get displayStatus {
    switch (status?.toLowerCase()) {
      case 'scheduled':
        return 'Scheduled';

      case 'ongoing':
        return 'Ongoing';

      case 'completed':
        return 'Completed';

      case 'cancelled':
        return 'Cancelled';

      default:
        return 'Unknown';
    }
  }

  // ============================================================
  // TIME
  // ============================================================

  String get formattedTime {
    if (startTime == null || endTime == null) {
      return '';
    }

    return '${_formatTime(startTime!)} - ${_formatTime(endTime!)}';
  }

  static String _formatTime(String time) {
    final parts = time.split(':');

    if (parts.length < 2) {
      return time;
    }

    int hour = int.tryParse(parts[0]) ?? 0;

    final minute = parts[1];

    final period = hour >= 12 ? 'PM' : 'AM';

    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }

    return '$hour:$minute $period';
  }

  // ============================================================
  // INTEGER PARSER
  // ============================================================

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