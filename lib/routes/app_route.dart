import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexorait_education_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:nexorait_education_app/features/class_schedule/presentaion/page/ongoing_class_page.dart';
import 'package:nexorait_education_app/features/payment/presentaion/pages/payment_page.dart';
import 'package:nexorait_education_app/features/payment/presentaion/pages/today_payment_page.dart';
import 'package:nexorait_education_app/features/student_classes/presentaion/pages/create_student_classes.dart';
import 'package:nexorait_education_app/features/students/presentaion/pages/create_student_page.dart';
import 'package:nexorait_education_app/features/students/presentaion/pages/student_custom_id_page.dart';
import 'package:nexorait_education_app/features/students/presentaion/pages/student_list_page.dart';
import 'package:nexorait_education_app/features/today_attendance/presentation/pages/today_attendance_page.dart';
import 'package:nexorait_education_app/features/today_classes/presentaion/page/today_classes_page.dart';

import '../features/admission/presentaion/page/admission_payment_page.dart';
import '../features/attendance/presentaion/pages/attendance_history_page.dart';
import '../features/attendance/presentaion/pages/attendance_page.dart';
import '../features/attendance/presentaion/pages/attendance_page_new.dart';
import '../features/attendance/presentaion/pages/attendance_report_page.dart';
import '../features/attendance/presentaion/pages/attendance_schedule_page.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../features/auth/presentation/pages/signin_page.dart';
import '../features/dashboard/presentaion/pages/dashboard_page.dart';
import '../features/image_upload/presentation/pages/student_image_capture_page.dart';
import '../features/payment/presentaion/pages/payment_history_view_page.dart';
import '../features/printer/presentaion/page/print_test_page.dart';
import '../features/qr/data/model/read_attendance/read_attendance_data_model.dart';
import '../features/qr/data/model/read_student_classes/read_student_classes_response_model.dart';
import '../features/qr/data/model/read_tute/read_tute_response_model.dart';
import '../features/qr/data/model/scan_attendance_new/scan_attendance_response_model.dart';
import '../features/qr/presentation/pages/qr_scanner_page.dart';
import '../features/splash_screen.dart';
import '../features/student_image/presentaion/pages/student_image_page.dart';
import '../features/student_tute/presentation/pages/create_tute_page.dart';
import '../features/student_tute/presentation/pages/tute_view_page.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final repository = AuthRepositoryImpl(AuthRemoteDataSource());
    final loginUseCase = LoginUseCase(repository);
    final logoutUseCase = LogoutUseCase(repository);

    final authBloc = AuthBloc(
      loginUseCase: loginUseCase,
      logoutUseCase: logoutUseCase,
    );

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/signup':
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider.value(value: authBloc, child: const SigninPage()),
        );

      case '/dashboard':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: authBloc, // re-use the same AuthBloc from login
            child: DashboardPage(),
          ),
        );

      case '/print_test_screen':
        return MaterialPageRoute(builder: (_) => PrintTestPage());

      case '/students':
        return MaterialPageRoute(builder: (_) => StudentListPage());
      case '/add-student-class':
        final response = settings.arguments as ReadStudentClassesResponseModel;

        return MaterialPageRoute(
          builder: (_) =>
              CreateStudentClasses(readStudentClassesState: response),
        );
      case '/create_student':
        return MaterialPageRoute(builder: (_) => CreateStudentPage());
      case '/student-id-numbers':
        final token = settings.arguments as String?;

        return MaterialPageRoute(
          builder: (_) => StudentCustomIdPage(token: token ?? ''),
        );
      case '/qr-scan':
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => QrScannerPage(
            scanType: args['type'], // required
            studentClassId: args['student_class_id'],
            classCategoryFeeId: args['class_category_fee_id'],
            classScheduleId: args['class_schedule_id'],
          ),
        );

      case '/today-class':
        return MaterialPageRoute(builder: (_) => TodayClassesPage());

      case '/class_ongoing':
        return MaterialPageRoute(builder: (_) => OngoingClassPage());

      case '/attendance-details':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => AttendancePage(
            classScheduleId: args['class_schedule_id'],
            attendanceData: args['attendanceData'] as ReadAttendanceDataModel,
            markMethod: args['mark_method'] as String?,
          ),
        );
      case '/attendance-details-new':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => AttendancePageNew(
            attendanceData:
                args['attendanceData'] as ScanAttendanceResponseModel,
            markMethod: args['mark_method'] as String?,
          ),
        );
      case '/attendance_schedule':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => AttendanceSchedulePage(
            studentClassId: args['student_class_id'],
            classCategoryFeeId: args['class_category_fee_id'],
            className: args['class_name'],
            categoryName: args['category_name'],
          ),
        );

      case '/attendance_report':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => AttendanceReportPage(scheduleId: args['schedule_id']),
        );
      case '/today-attendance':
        final args = settings.arguments as Map<String, dynamic>; // cast as Map

        return MaterialPageRoute(
          builder: (_) => TodayAttendancePage(
            token: args['token'], // pass the token
            classId: args['class_id'], // pass the classId
            attendanceId: args['attendance_id'], // pass the attendanceId
            classCategory:
                args['class_has_category_id'], // pass the classCategory
          ),
        );
      case '/attendance-history':
        final args = settings.arguments as Map<String, dynamic>; // cast as Map

        return MaterialPageRoute(
          builder: (_) => AttendanceHistoryPage(
            studentId: args['student_id'],
            enrollmentId: args['enrollment_id'],
          ),
        );

      case '/image_capture':
        return MaterialPageRoute(
          builder: (_) => StudentImageCapturePage(
            registered:
                (settings.arguments as Map<String, dynamic>)['registered']
                    as bool? ??
                false,
          ),
        );
      case '/payment-details':
        final args = settings.arguments as Map<String, dynamic>; // cast as Map

        return MaterialPageRoute(
          builder: (_) => PaymentPage(
            paymentState: args['paymentState'], // pass the loaded state
            markMethod: args['mark_method'] as String?,
          ),
        );
      case '/today-payment':
        return MaterialPageRoute(builder: (_) => TodayPaymentPage());
      case '/admission-payment':
        return MaterialPageRoute(builder: (_) => AdmissionPaymentPage());
      case '/student-tute-screen':
        final response = settings.arguments as ReadTuteResponseModel;

        return MaterialPageRoute(
          builder: (_) => CreateTutePage(readTuteResponse: response),
        );
      case '/tute':
        final args = settings.arguments as Map<String, dynamic>; // cast as Map
        return MaterialPageRoute(
          builder: (_) => TuteViewPage(
            studentId: args['student_id'], // pass the studentId
            enrollmentId:
                args['enrollment_id'], // pass the classCategoryStudentClassId
          ),
        );
      case '/payment-history':
        final args = settings.arguments as Map<String, dynamic>; // cast as Map

        return MaterialPageRoute(
          builder: (_) => PaymentHistoryViewPage(
            studentId: args['student_id'],
            enrollmentId: args['enrollment_id'],
          ),
        );
      case '/student_image_page':
        return MaterialPageRoute(builder: (_) => StudentImagePage());
      // case '/user-profile':
      //   final args = settings.arguments as Map<String, dynamic>;

      //   return MaterialPageRoute(
      //     builder: (_) =>
      //         UserProfilePage(token: args['token'], user: args['user_model']),
      //   );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider.value(value: authBloc, child: const SigninPage()),
        );
    }
  }
}
