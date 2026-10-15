import '../../data/models/payment_history/payment_history_request_model.dart';
import '../../data/models/payment_history/payment_history_response_model.dart';
import '../repositories/mark_payment_repository.dart';

class GetPaymentHistoryUseCase {
  final MarkPaymentRepository repository;

  GetPaymentHistoryUseCase(this.repository);

  Future<PaymentHistoryResponseModel> call({
    required PaymentHistoryRequestModel requestModel,
  }) {
    return repository.getPaymentHistory(
      requestModel: requestModel,
    );
  }
}