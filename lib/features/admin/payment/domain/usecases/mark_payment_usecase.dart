
import '../../data/models/mark_payment_request_model.dart';
import '../../data/models/mark_payment_response_model.dart';
import '../repositories/mark_payment_repository.dart';

class MarkPaymentUseCase {
  final MarkPaymentRepository repository;

  const MarkPaymentUseCase(this.repository);

  Future<MarkPaymentResponseModel> call({
    required MarkPaymentRequestModel requestModel,
  }) {
    return repository.markPayment(requestModel: requestModel);
  }
}
