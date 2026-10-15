import 'package:get_it/get_it.dart';

import '../../features/admin/admission/core/admission_injection.dart';
import '../../features/admin/attendance/core/mark_attendance_injection.dart';
import '../../features/admin/class_schedule/core/class_schedule_injection.dart';
import '../../features/admin/dashboard/core/mobile_dashboard_injection.dart';
import '../../features/admin/image_upload/core/image_upload_injection.dart';
import '../../features/admin/institute_hall/core/institute_hall_injection.dart';
import '../../features/admin/payment/core/mark_payment_injection.dart';
import '../../features/admin/qr/core/read_attendance_injection.dart';
import '../../features/admin/qr/core/read_payment_injection.dart';
import '../../features/admin/qr/core/read_student_classes_injection.dart';
import '../../features/admin/qr/core/read_tute_injection.dart';
import '../../features/admin/qr/core/scan_attendance_injection.dart';
import '../../features/admin/qr/core/scan_payment_injection.dart';
import '../../features/admin/student_card/core/student_card_injection.dart';
import '../../features/admin/student_classes/core/class_room_injection.dart';
import '../../features/admin/student_grade/core/student_grade_injection.dart';
import '../../features/admin/student_image/core/student_image_injection.dart';
import '../../features/admin/student_tute/core/tute_injection.dart';
import '../../features/admin/students/core/read_student_injection.dart';
import '../../features/admin/students/core/student_classes_injection.dart';
import '../../features/admin/students/core/student_injection.dart';
import '../../features/admin/today_attendance/core/daily_attendance_details_injection.dart';
import '../../features/admin/today_classes/core/init_today_class_injection.dart';
import '../../features/auth/core/auth_injection.dart' as authDI;
import '../../features/teacher/classess/core/teacher_classes_injection.dart';
import '../../features/teacher/dashboard/core/teacher_dashboard_injection.dart';
import '../../features/teacher/students/core/teacher_student_injection.dart';
import '../../features/teacher/timetable/core/teacher_timetable_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await authDI.initAuthDI();
  await initStudentGradeDI();
  await initStudentDI();
  await initStudentClassesDI();
  await initReadStudentDI();
  await initReadPaymentDI();
  await initMarkPaymentDI();
  await initReadAttendanceDI();
  await initScanAttendanceDI();
  await initMarkAttendanceDI();
  await initImageUploadDI();
  await initMobileDashboardDI();
  await initDailyAttendanceDetailsDI();
  await initStudentImageDI();
  await initTuteDI();
  await initReadTuteDI();
  await initReadStudentClassDI();
  await initClassRoomDI();
  await initTodayAttendanceDI();
  await initAdmissionDI();
  await classScheduleDI();
  await initInstituteHallsDI();
  await initStudentCardDI();
  await initScanPaymentDI();

  //Teacher DI
  await initTeacherDashboardDI();
  await initTeacherClassesDI();
  await initTeacherTimetableDI();
  await initTeacherStudentsDI();
  
}
