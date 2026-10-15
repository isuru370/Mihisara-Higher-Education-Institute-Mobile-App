import '../../domain/repositories/read_tute_repository.dart';
import '../datasources/read_tute_remote_datasource.dart';
import '../model/read_tute/read_tute_response_model.dart';

class ReadTuteRepositoryImpl implements ReadTuteRepository {
  final ReadTuteRemoteDataSource remoteDataSource;

  ReadTuteRepositoryImpl(this.remoteDataSource);

  @override
  Future<ReadTuteResponseModel> readTute({
    required String qrCode,
  }) {
    return remoteDataSource.readTute(qrCode: qrCode);
  }
}