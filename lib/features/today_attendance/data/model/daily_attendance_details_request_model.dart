class DailyAttendanceDetailsRequestModel {
  final int classId;
  final int attendanceId;
  final int classCategoryStudentClassId;

  DailyAttendanceDetailsRequestModel({
    required this.classId,
    required this.attendanceId,
    required this.classCategoryStudentClassId,
  });

  Map<String, dynamic> toJson() {
    return {
      "class_id": classId,
      "attendance_id": attendanceId,
      "class_category_student_class_id":
          classCategoryStudentClassId,
    };
  }
}
