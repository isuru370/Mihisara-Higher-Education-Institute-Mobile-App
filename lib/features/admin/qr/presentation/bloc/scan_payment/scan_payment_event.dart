part of 'scan_payment_bloc.dart';

sealed class ScanPaymentEvent extends Equatable {
  const ScanPaymentEvent();

  @override
  List<Object> get props => [];
}

/// Scan student payment details using QR / student code.
final class ScanPaymentRequested extends ScanPaymentEvent {
  final ScanPaymentRequestModel requestModel;

  const ScanPaymentRequested({
    required this.requestModel,
  });

  @override
  List<Object> get props => [requestModel];
}

/// Clear currently loaded payment data.
final class ScanPaymentReset extends ScanPaymentEvent {
  const ScanPaymentReset();
}