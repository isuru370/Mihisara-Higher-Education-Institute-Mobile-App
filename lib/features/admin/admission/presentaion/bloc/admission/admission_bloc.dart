import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../students/data/models/create_student/create_student_response_model.dart';
import '../../../data/model/admission/admission_response_model.dart';
import '../../../data/model/payment/admission_payment_response_model.dart';
import '../../../data/model/store/admission_payment_request_model.dart';
import '../../../domain/usecase/fetch_admission_payment_usecase.dart';
import '../../../domain/usecase/fetch_admission_usecase.dart';
import '../../../domain/usecase/store_admission_payment_usecase.dart';

part 'admission_event.dart';
part 'admission_state.dart';

class AdmissionBloc extends Bloc<AdmissionEvent, AdmissionState> {
  final FetchAdmissionUsecase fetchAdmissionUsecase;
  final FetchAdmissionPaymentUsecase fetchAdmissionPaymentUsecase;
  final StoreAdmissionPaymentUseCase storeAdmissionPaymentUseCase;

  AdmissionBloc({
    required this.fetchAdmissionUsecase,
    required this.fetchAdmissionPaymentUsecase,
    required this.storeAdmissionPaymentUseCase,
  }) : super(AdmissionInitial()) {
    on<FetchAdmissionDataEvent>(_onFetchAdmissionData);
    on<FetchAdmissionPaymentDataEvent>(_onFetchAdmissionPaymentData);
    on<StoreAdmissionPaymentEvent>(_onStoreAdmissionPayment);
  }

  Future<void> _onFetchAdmissionData(
    FetchAdmissionDataEvent event,
    Emitter<AdmissionState> emit,
  ) async {
    emit(AdmissionLoading());

    try {
      final response = await fetchAdmissionUsecase();

      emit(AdmissionLoaded(admissionData: response));
    } catch (e) {
      emit(AdmissionError(message: e.toString()));
    }
  }

  Future<void> _onFetchAdmissionPaymentData(
    FetchAdmissionPaymentDataEvent event,
    Emitter<AdmissionState> emit,
  ) async {
    emit(AdmissionLoading());

    try {
      final response = await fetchAdmissionPaymentUsecase();

      emit(AdmissionPaymentLoaded(paymentData: response));
    } catch (e) {
      emit(AdmissionError(message: e.toString()));
    }
  }

  Future<void> _onStoreAdmissionPayment(
    StoreAdmissionPaymentEvent event,
    Emitter<AdmissionState> emit,
  ) async {
    emit(AdmissionPaymentStoring());

    try {
      final response = await storeAdmissionPaymentUseCase(event.request);

      emit(AdmissionPaymentStored(response: response));
    } catch (e) {
      emit(AdmissionError(message: e.toString()));
    }
  }
}
