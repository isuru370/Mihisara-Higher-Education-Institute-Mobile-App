import '../../data/model/read_tute/read_tute_response_model.dart';
import '../repositories/read_tute_repository.dart';

class ReadTuteUseCase {
  final ReadTuteRepository repository;

  ReadTuteUseCase(this.repository);

  Future<ReadTuteResponseModel> call({
    required String qrCode,
  }) {
    return repository.readTute(qrCode: qrCode);
  }
}