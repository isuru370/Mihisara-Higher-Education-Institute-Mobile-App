
import '../../data/model/scan_payment_new/scan_payment_request_model.dart';
import '../../data/model/scan_payment_new/scan_payment_response_model.dart';

abstract class ScanPaymentRepository {
  Future<ScanPaymentResponseModel> readPayment({
    required ScanPaymentRequestModel requestModel,
  });
}