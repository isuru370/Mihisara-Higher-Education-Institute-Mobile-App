import 'package:nexorait_education_app/features/payment/data/models/mark_payment_response_model.dart';

import '../../domain/repositories/mark_payment_repository.dart';
import '../datasources/mark_payment_remote_data_source.dart';
import '../models/mark_payment_request_model.dart';
import '../models/payment_history/payment_history_request_model.dart';
import '../models/payment_history/payment_history_response_model.dart';
import '../models/today_payments/today_payments_request_model.dart';
import '../models/today_payments/today_payments_response_model.dart';

class MarkPaymentRepositoryImpl implements MarkPaymentRepository {
  final MarkPaymentRemoteDataSource remoteDataSource;

  const MarkPaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<MarkPaymentResponseDataModel> markPayment({
    required MarkPaymentRequestModel requestModel,
  }) {
    return remoteDataSource.markPayment(requestModel: requestModel);
  }

  @override
  Future<TodayPaymentsResponseModel> getTodayPayments({
    required TodayPaymentsRequestModel requestModel,
  }) {
    return remoteDataSource.getTodayPayments(requestModel: requestModel);
  }

  @override
  Future<PaymentHistoryResponseModel> getPaymentHistory({
    required PaymentHistoryRequestModel requestModel,
  }) {
    return remoteDataSource.getPaymentHistory(requestModel: requestModel);
  }
}
