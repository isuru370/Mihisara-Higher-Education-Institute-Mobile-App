import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/read_payment/read_payments_response_model.dart';
import '../../../domain/usecases/read_payment_usecase.dart';

part 'read_payment_event.dart';
part 'read_payment_state.dart';

class ReadPaymentBloc extends Bloc<ReadPaymentEvent, ReadPaymentState> {
  final ReadPaymentUseCase readPaymentUseCase;

  ReadPaymentBloc({required this.readPaymentUseCase})
    : super(const ReadPaymentInitial()) {
    on<ReadPaymentRequested>(_onReadPaymentRequested);
    on<ResetReadPayment>(_onResetReadPayment);
  }

  Future<void> _onReadPaymentRequested(
    ReadPaymentRequested event,
    Emitter<ReadPaymentState> emit,
  ) async {
    final previousResponse = state is ReadPaymentLoaded
        ? (state as ReadPaymentLoaded).response
        : null;

    emit(ReadPaymentLoading(previousResponse: previousResponse));

    try {
      final result = await readPaymentUseCase(qrCode: event.qrCode);

      emit(ReadPaymentLoaded(result));
    } catch (e) {
      emit(ReadPaymentError(message: e.toString()));
    }
  }

  void _onResetReadPayment(
    ResetReadPayment event,
    Emitter<ReadPaymentState> emit,
  ) {
    emit(const ReadPaymentInitial());
  }
}
