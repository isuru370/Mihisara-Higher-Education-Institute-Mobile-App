import '../../data/model/class_categry/class_category_request_model.dart';
import '../../data/model/class_categry/class_category_response_model.dart';
import '../../data/model/newday/class_new_day_request_model.dart';
import '../../data/model/newday/class_new_day_response_model.dart';
import '../../data/model/ongoing/ongoing_class_response_model.dart';
import '../../data/model/schedule/class_schedule_request_model.dart';
import '../../data/model/schedule/class_schedule_response_model.dart';
import '../../data/model/update/update_class_schedule_request_model.dart';
import '../../data/model/update/update_class_schedule_response_model.dart';
import '../../data/model/cancel/class_cancel_request_model.dart';
import '../../data/model/cancel/class_cancel_response_model.dart';

abstract class ClassScheduleRepository {
  Future<OngoingClassResponseModel>
      fetchOngoingClass();

  Future<ClassScheduleResponseModel>
      fetchClassSchedule(
    ClassScheduleRequestModel request,
  );

  Future<ClassNewDayResponseModel>
      addNewDay(
    ClassNewDayRequestModel request,
  );

  Future<UpdateClassScheduleResponseModel>
      updateSchedule(
    UpdateClassScheduleRequestModel request,
  );

  Future<ClassCancelResponseModel>
      cancelSchedule(
    ClassCancelRequestModel request,
  );
  
  Future<ClassCategoryResponseModel>
    fetchClassCategory(
  ClassCategoryRequestModel request,
);
}