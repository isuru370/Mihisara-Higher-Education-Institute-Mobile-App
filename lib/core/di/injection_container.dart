import 'package:get_it/get_it.dart';

import '../../features/admission/core/admission_injection.dart';
import '../../features/attendance/core/mark_attendance_injection.dart';
import '../../features/auth/core/auth_injection.dart' as authDI;
import '../../features/class_schedule/core/class_schedule_injection.dart';
import '../../features/dashboard/core/mobile_dashboard_injection.dart';
import '../../features/image_upload/core/image_upload_injection.dart';
import '../../features/institute_hall/core/institute_hall_injection.dart';
import '../../features/payment/core/mark_payment_injection.dart';
import '../../features/qr/core/read_attendance_injection.dart';
import '../../features/qr/core/read_payment_injection.dart';
import '../../features/qr/core/read_student_classes_injection.dart';
import '../../features/qr/core/read_tute_injection.dart';
import '../../features/student_classes/core/class_room_injection.dart';
import '../../features/student_grade/core/student_grade_injection.dart';
import '../../features/student_image/core/student_image_injection.dart';
import '../../features/students/core/read_student_injection.dart';
import '../../features/students/core/student_classes_injection.dart';
import '../../features/students/core/student_injection.dart';
import '../../features/today_attendance/core/daily_attendance_details_injection.dart';
import '../../features/today_classes/core/init_today_class_injection.dart';
import '../../features/student_tute/core/tute_injection.dart';

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
}
