import 'package:nexorait_education_app/features/class_schedule/data/model/attendance_schedule/attendance_schedule_request_model.dart';
import 'package:nexorait_education_app/features/class_schedule/data/model/attendance_schedule/attendance_schedule_response_model.dart';

import '../../domain/repository/class_schedule_repository.dart';
import '../datasources/class_schedule_remote_datasource.dart';
import '../model/cancel/class_cancel_request_model.dart';
import '../model/cancel/class_cancel_response_model.dart';
import '../model/class_categry/class_category_request_model.dart';
import '../model/class_categry/class_category_response_model.dart';
import '../model/newday/class_new_day_request_model.dart';
import '../model/newday/class_new_day_response_model.dart';
import '../model/ongoing/ongoing_class_response_model.dart';
import '../model/schedule/class_schedule_request_model.dart';
import '../model/schedule/class_schedule_response_model.dart';
import '../model/update/update_class_schedule_request_model.dart';
import '../model/update/update_class_schedule_response_model.dart';

class ClassScheduleRepositoryImpl implements ClassScheduleRepository {
  final ClassScheduleRemoteDatasource remoteDataSource;

  ClassScheduleRepositoryImpl(this.remoteDataSource);

  @override
  Future<OngoingClassResponseModel> fetchOngoingClass() {
    return remoteDataSource.fetchOngoingClass();
  }

  @override
  Future<ClassScheduleResponseModel> fetchClassSchedule(
    ClassScheduleRequestModel request,
  ) {
    return remoteDataSource.fetchClassSchedule(request);
  }

  @override
  Future<ClassNewDayResponseModel> addNewDay(ClassNewDayRequestModel request) {
    return remoteDataSource.addNewDay(request);
  }

  @override
  Future<UpdateClassScheduleResponseModel> updateSchedule(
    UpdateClassScheduleRequestModel request,
  ) {
    return remoteDataSource.updateSchedule(request);
  }

  @override
  Future<ClassCancelResponseModel> cancelSchedule(
    ClassCancelRequestModel request,
  ) {
    return remoteDataSource.cancelSchedule(request);
  }

  @override
  Future<ClassCategoryResponseModel> fetchClassCategory(
    ClassCategoryRequestModel request,
  ) {
    return remoteDataSource.fetchClassCategory(request);
  }

  @override
  Future<AttendanceScheduleResponseModel> fetchClassCategoryById(
    AttendanceScheduleRequestModel request,
  ) {
    return remoteDataSource.fetchAttendanceSchedules(request);
  }
}
