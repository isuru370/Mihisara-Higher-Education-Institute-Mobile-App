part of 'read_payment_bloc.dart';

sealed class ReadPaymentEvent extends Equatable {
  const ReadPaymentEvent();

  @override
  List<Object?> get props => [];
}

class ReadPaymentRequested extends ReadPaymentEvent {
  final String qrCode;

  const ReadPaymentRequested(this.qrCode);

  @override
  List<Object?> get props => [qrCode];
}

class ResetReadPayment extends ReadPaymentEvent {}