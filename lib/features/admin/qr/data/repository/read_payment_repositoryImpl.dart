import '../../domain/repositories/read_payment_repository.dart';
import '../datasources/read_payment_remote_datasource.dart';
import '../model/read_payment/read_payments_response_model.dart';

class ReadPaymentRepositoryImpl implements ReadPaymentRepository {
  final ReadPaymentRemoteDataSource remoteDataSource;

  ReadPaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<ReadPaymentResponseModel> readPayment({
    required String qrCode,
  }) {
    return remoteDataSource.readPayment(
      qrCode: qrCode,
    );
  }
}
