import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/scan_payment_new/scan_payment_request_model.dart';
import '../../../data/model/scan_payment_new/scan_payment_response_model.dart';
import '../../../domain/usecases/scan_payment_usecase.dart';



part 'scan_payment_event.dart';
part 'scan_payment_state.dart';

class ScanPaymentBloc
    extends Bloc<ScanPaymentEvent, ScanPaymentState> {
  final ScanPaymentUsecase scanPaymentUsecase;

  ScanPaymentBloc({
    required this.scanPaymentUsecase,
  }) : super(ScanPaymentInitial()) {
    on<ScanPaymentRequested>(_onScanPaymentRequested);
    on<ScanPaymentReset>(_onScanPaymentReset);
  }

  Future<void> _onScanPaymentRequested(
    ScanPaymentRequested event,
    Emitter<ScanPaymentState> emit,
  ) async {
    emit(ScanPaymentLoading());

    try {
      final response = await scanPaymentUsecase(
        requestModel: event.requestModel,
      );

      emit(
        ScanPaymentLoaded(
          response: response,
        ),
      );
    } catch (e) {
      emit(
        ScanPaymentError(
          message: e.toString().replaceFirst(
                'Exception: ',
                '',
              ),
        ),
      );
    }
  }

  void _onScanPaymentReset(
    ScanPaymentReset event,
    Emitter<ScanPaymentState> emit,
  ) {
    emit(ScanPaymentInitial());
  }
}