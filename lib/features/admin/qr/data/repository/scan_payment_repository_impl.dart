import '../../domain/repositories/scan_payment_repository.dart';
import '../datasources/scan_payment_remote_datasource.dart';
import '../model/scan_payment_new/scan_payment_request_model.dart';
import '../model/scan_payment_new/scan_payment_response_model.dart';

class ScanPaymentRepositoryImpl
    implements ScanPaymentRepository {
  final ScanPaymentRemoteDatasource remoteDatasource;

  ScanPaymentRepositoryImpl(
     this.remoteDatasource,
  );

  @override
  Future<ScanPaymentResponseModel> readPayment({
    required ScanPaymentRequestModel requestModel,
  }) {
    return remoteDatasource.readPayment(
      requestModel: requestModel,
    );
  }
}