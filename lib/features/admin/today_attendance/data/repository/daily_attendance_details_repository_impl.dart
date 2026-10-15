import '../../domain/repository/daily_attendance_details_repository.dart';
import '../datasources/daily_attendance_details_remote_datasource.dart';
import '../model/daily_attendance_details_request_model.dart';
import '../model/daily_attendance_details_response_model.dart';

class DailyAttendanceDetailsRepositoryImpl
    implements DailyAttendanceDetailsRepository {
  final DailyAttendanceDetailsRemoteDataSource remoteDataSource;

  DailyAttendanceDetailsRepositoryImpl(this.remoteDataSource);

  @override
  Future<DailyAttendanceDetailsResponseModel> getDailyAttendanceDetails({
    required String token,
    required DailyAttendanceDetailsRequestModel request,
  }) {
    return remoteDataSource.getDailyAttendanceDetails(
      token: token,
      request: request,
    );
  }
}
