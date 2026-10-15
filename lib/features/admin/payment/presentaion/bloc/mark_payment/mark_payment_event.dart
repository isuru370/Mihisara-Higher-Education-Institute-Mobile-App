part of 'mark_payment_bloc.dart';

abstract class MarkPaymentEvent extends Equatable {
  const MarkPaymentEvent();

  @override
  List<Object> get props => [];
}

class MarkPaymentRequested extends MarkPaymentEvent {
  final MarkPaymentRequestModel requestModel;

  const MarkPaymentRequested({
    required this.requestModel,
  });

  @override
  List<Object> get props => [requestModel];
}

class TodayPaymentsRequested extends MarkPaymentEvent {
  final TodayPaymentsRequestModel requestModel;

  const TodayPaymentsRequested({
    required this.requestModel,
  });

  @override
  List<Object> get props => [requestModel];
}

class PaymentHistoryRequested extends MarkPaymentEvent {
  final PaymentHistoryRequestModel requestModel;

  const PaymentHistoryRequested({
    required this.requestModel,
  });

  @override
  List<Object> get props => [requestModel];
}

class ResetMarkPayment extends MarkPaymentEvent {
  const ResetMarkPayment();
}