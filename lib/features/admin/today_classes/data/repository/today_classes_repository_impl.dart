import '../../domain/repository/today_classes_repository.dart';
import '../datasources/today_classes_remote_data_source.dart';
import '../models/today_classes_response_model.dart';

class TodayClassesRepositoryImpl implements TodayClassesRepository {
  final TodayClassesRemoteDataSource remoteDataSource;

  TodayClassesRepositoryImpl(this.remoteDataSource);

  @override
  Future<TodayClassesResponseModel> getTodayClasses() {
    return remoteDataSource.getTodayClasses();
  }
}
