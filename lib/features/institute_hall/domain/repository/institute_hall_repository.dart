import '../../data/model/institute_hall_response_model.dart';

abstract class InstituteHallRepository {
  Future<InstituteHallResponseModel> fetchInstituteHalls();
}