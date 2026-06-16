import '../../domain/repository/institute_hall_repository.dart';
import '../datasources/institute_hall_remote_datasource.dart';
import '../model/institute_hall_response_model.dart';

class InstituteHallRepositoryImpl implements InstituteHallRepository {
  final InstituteHallRemoteDatasource remoteDatasource;

  InstituteHallRepositoryImpl(this.remoteDatasource);

  @override
  Future<InstituteHallResponseModel> fetchInstituteHalls() {
    return remoteDatasource.fetchInstituteHalls();
  }
}
