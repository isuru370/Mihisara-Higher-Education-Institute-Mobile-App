import '../../data/model/scan_payment_new/scan_payment_request_model.dart';
import '../../data/model/scan_payment_new/scan_payment_response_model.dart';
import '../repositories/scan_payment_repository.dart';

class ScanPaymentUsecase {
  final ScanPaymentRepository repository;

  ScanPaymentUsecase(this.repository);

  Future<ScanPaymentResponseModel> call({
    required ScanPaymentRequestModel requestModel,
  }) {
    return repository.readPayment(requestModel: requestModel);
  }
}
