

import '../../data/models/today_payments/today_payments_request_model.dart';
import '../../data/models/today_payments/today_payments_response_model.dart';
import '../repositories/mark_payment_repository.dart';

class GetTodayPaymentsUseCase {
  final MarkPaymentRepository repository;

  const GetTodayPaymentsUseCase(
    this.repository,
  );

  Future<TodayPaymentsResponseModel> call({
    required TodayPaymentsRequestModel requestModel,
  }) {
    return repository.getTodayPayments(
      requestModel: requestModel,
    );
  }
}