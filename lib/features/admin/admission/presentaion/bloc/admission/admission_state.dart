part of 'admission_bloc.dart';

sealed class AdmissionState extends Equatable {
  const AdmissionState();
  
  @override
  List<Object> get props => [];
}

final class AdmissionInitial extends AdmissionState {}

final class AdmissionLoading extends AdmissionState {}

final class AdmissionLoaded extends AdmissionState {
  final AdmissionResponseModel admissionData;

  const AdmissionLoaded({required this.admissionData});

  @override
  List<Object> get props => [admissionData];
}

final class AdmissionError extends AdmissionState {
  final String message;

  const AdmissionError({required this.message});

  @override
  List<Object> get props => [message];
}

class AdmissionPaymentLoaded extends AdmissionState {
  final AdmissionPaymentResponseModel paymentData;

  const AdmissionPaymentLoaded({required this.paymentData});

  @override
  List<Object> get props => [paymentData];
}

final class AdmissionPaymentStoring extends AdmissionState {}

final class AdmissionPaymentStored extends AdmissionState {
  final CreateStudentResponseModel response;

  const AdmissionPaymentStored({
    required this.response,
  });

  @override
  List<Object> get props => [response];
}
