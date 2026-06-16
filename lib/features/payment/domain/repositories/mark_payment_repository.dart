import '../../data/models/mark_payment_request_model.dart';
import '../../data/models/mark_payment_response_model.dart';
import '../../data/models/payment_history/payment_history_request_model.dart';
import '../../data/models/payment_history/payment_history_response_model.dart';
import '../../data/models/today_payments/today_payments_request_model.dart';
import '../../data/models/today_payments/today_payments_response_model.dart';

abstract class MarkPaymentRepository {
  Future<MarkPaymentResponseDataModel> markPayment({
    required MarkPaymentRequestModel requestModel,
  });
  Future<TodayPaymentsResponseModel> getTodayPayments({
    required TodayPaymentsRequestModel requestModel,
  });
  Future<PaymentHistoryResponseModel> getPaymentHistory({
    required PaymentHistoryRequestModel requestModel,
  });
}
