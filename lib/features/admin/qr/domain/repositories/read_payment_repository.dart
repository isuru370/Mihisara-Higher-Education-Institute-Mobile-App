import '../../data/model/read_payment/read_payments_response_model.dart';

abstract class ReadPaymentRepository {
  Future<ReadPaymentResponseModel> readPayment({
    required String qrCode,
  });
}
