part of 'scan_payment_bloc.dart';

sealed class ScanPaymentState extends Equatable {
  const ScanPaymentState();

  @override
  List<Object> get props => [];
}

final class ScanPaymentInitial extends ScanPaymentState {}

final class ScanPaymentLoading extends ScanPaymentState {}

final class ScanPaymentLoaded extends ScanPaymentState {
  final ScanPaymentResponseModel response;

  const ScanPaymentLoaded({
    required this.response,
  });

  @override
  List<Object> get props => [response];
}

final class ScanPaymentError extends ScanPaymentState {
  final String message;

  const ScanPaymentError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}