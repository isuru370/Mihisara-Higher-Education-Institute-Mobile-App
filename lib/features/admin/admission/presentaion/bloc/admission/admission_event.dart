part of 'admission_bloc.dart';

sealed class AdmissionEvent extends Equatable {
  const AdmissionEvent();

  @override
  List<Object> get props => [];
}

class FetchAdmissionDataEvent extends AdmissionEvent {}

class FetchAdmissionPaymentDataEvent extends AdmissionEvent {}

class StoreAdmissionPaymentEvent extends AdmissionEvent {
  final AdmissionPaymentRequestModel request;

  const StoreAdmissionPaymentEvent({
    required this.request,
  });

  @override
  List<Object> get props => [request];
}
