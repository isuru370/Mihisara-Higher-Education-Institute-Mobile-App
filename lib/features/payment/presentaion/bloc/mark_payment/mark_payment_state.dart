part of 'mark_payment_bloc.dart';

abstract class MarkPaymentState extends Equatable {
  const MarkPaymentState();

  @override
  List<Object> get props => [];
}

class MarkPaymentInitial extends MarkPaymentState {}

class MarkPaymentLoading extends MarkPaymentState {}

class MarkPaymentLoaded extends MarkPaymentState {
  final MarkPaymentResponseDataModel response;

  const MarkPaymentLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class MarkPaymentError extends MarkPaymentState {
  final String message;

  const MarkPaymentError({required this.message});

  @override
  List<Object> get props => [message];
}

class TodayPaymentsLoading extends MarkPaymentState {}

class TodayPaymentsLoaded extends MarkPaymentState {
  final TodayPaymentsResponseModel response;

  const TodayPaymentsLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class TodayPaymentsError extends MarkPaymentState {
  final String message;

  const TodayPaymentsError({required this.message});

  @override
  List<Object> get props => [message];
}

class PaymentHistoryLoading extends MarkPaymentState {}

class PaymentHistoryLoaded extends MarkPaymentState {
  final PaymentHistoryResponseModel response;

  const PaymentHistoryLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class PaymentHistoryError extends MarkPaymentState {
  final String message;

  const PaymentHistoryError({required this.message});

  @override
  List<Object> get props => [message];
}
