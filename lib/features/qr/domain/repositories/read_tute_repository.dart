import '../../data/model/read_tute/read_tute_response_model.dart';

abstract class ReadTuteRepository {
  Future<ReadTuteResponseModel> readTute({
    required String qrCode,
  });
}