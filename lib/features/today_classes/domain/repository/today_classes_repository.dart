import '../../data/models/today_classes_response_model.dart';

abstract class TodayClassesRepository {
  Future<TodayClassesResponseModel> getTodayClasses();
}