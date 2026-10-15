import '../repository/institute_hall_repository.dart';
import '../../data/model/institute_hall_response_model.dart';

class FetchInstituteHall {
  final InstituteHallRepository repository;

  FetchInstituteHall(this.repository);

  Future<InstituteHallResponseModel> call() {
    return repository.fetchInstituteHalls();
  }
}