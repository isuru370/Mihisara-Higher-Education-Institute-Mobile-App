part of 'read_payment_bloc.dart';

sealed class ReadPaymentState extends Equatable {
  const ReadPaymentState();

  @override
  List<Object?> get props => [];
}

class ReadPaymentInitial extends ReadPaymentState {
  const ReadPaymentInitial();
}

class ReadPaymentLoading extends ReadPaymentState {
  final ReadPaymentResponseModel? previousResponse;

  const ReadPaymentLoading({this.previousResponse});

  @override
  List<Object?> get props => [previousResponse];
}

class ReadPaymentLoaded extends ReadPaymentState {
  final ReadPaymentResponseModel response;

  const ReadPaymentLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class ReadPaymentError extends ReadPaymentState {
  final String message;

  const ReadPaymentError({required this.message});

  @override
  List<Object?> get props => [message];
}