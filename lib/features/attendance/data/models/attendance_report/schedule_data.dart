import 'student_class_data.dart';
import 'class_category_fee_data.dart';

class ScheduleData {
  final int id;
  final int studentClassId;
  final int classCategoryFeeId;
  final String classDate;
  final String startTime;
  final String endTime;
  final String status;
  final StudentClassData studentClass;
  final ClassCategoryFeeData classCategoryFee;

  ScheduleData({
    required this.id,
    required this.studentClassId,
    required this.classCategoryFeeId,
    required this.classDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.studentClass,
    required this.classCategoryFee,
  });

  factory ScheduleData.fromJson(Map<String, dynamic> json) {
    return ScheduleData(
      id: json['id'] ?? 0,
      studentClassId: json['student_class_id'] ?? 0,
      classCategoryFeeId: json['class_category_fee_id'] ?? 0,
      classDate: json['class_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      status: json['status'] ?? '',
      studentClass: StudentClassData.fromJson(json['student_class'] ?? {}),
      classCategoryFee: ClassCategoryFeeData.fromJson(json['class_category_fee'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_class_id': studentClassId,
      'class_category_fee_id': classCategoryFeeId,
      'class_date': classDate,
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
      'student_class': studentClass.toJson(),
      'class_category_fee': classCategoryFee.toJson(),
    };
  }
}