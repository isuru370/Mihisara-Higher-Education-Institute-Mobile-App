import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/mark_payment_request_model.dart';
import '../../../data/models/mark_payment_response_model.dart';
import '../../../data/models/payment_history/payment_history_request_model.dart';
import '../../../data/models/payment_history/payment_history_response_model.dart';
import '../../../data/models/today_payments/today_payments_request_model.dart';
import '../../../data/models/today_payments/today_payments_response_model.dart';
import '../../../domain/usecases/get_payment_history_usecase.dart';
import '../../../domain/usecases/get_today_payments_usecase.dart';
import '../../../domain/usecases/mark_payment_usecase.dart';

part 'mark_payment_event.dart';
part 'mark_payment_state.dart';

class MarkPaymentBloc extends Bloc<MarkPaymentEvent, MarkPaymentState> {
  final MarkPaymentUseCase markPaymentUseCase;
  final GetTodayPaymentsUseCase getTodayPaymentsUseCase;
  final GetPaymentHistoryUseCase getPaymentHistoryUseCase;

  MarkPaymentBloc({
    required this.markPaymentUseCase,
    required this.getTodayPaymentsUseCase,
    required this.getPaymentHistoryUseCase,
  }) : super(MarkPaymentInitial()) {
    on<MarkPaymentRequested>(_onMarkPaymentRequested);
    on<TodayPaymentsRequested>(_onTodayPaymentsRequested);
    on<PaymentHistoryRequested>(_onPaymentHistoryRequested);
    on<ResetMarkPayment>(_onResetMarkPayment);
  }

  Future<void> _onMarkPaymentRequested(
    MarkPaymentRequested event,
    Emitter<MarkPaymentState> emit,
  ) async {
    emit(MarkPaymentLoading());

    try {
      final response = await markPaymentUseCase(
        requestModel: event.requestModel,
      );

      emit(MarkPaymentLoaded(response: response));
    } catch (e) {
      emit(MarkPaymentError(message: _extractErrorMessage(e)));
    }
  }

  Future<void> _onTodayPaymentsRequested(
    TodayPaymentsRequested event,
    Emitter<MarkPaymentState> emit,
  ) async {
    emit(TodayPaymentsLoading());

    try {
      final response = await getTodayPaymentsUseCase(
        requestModel: event.requestModel,
      );

      emit(TodayPaymentsLoaded(response: response));
    } catch (e) {
      emit(TodayPaymentsError(message: _extractErrorMessage(e)));
    }
  }

  Future<void> _onPaymentHistoryRequested(
    PaymentHistoryRequested event,
    Emitter<MarkPaymentState> emit,
  ) async {
    emit(PaymentHistoryLoading());

    try {
      final response = await getPaymentHistoryUseCase(
        requestModel: event.requestModel,
      );

      emit(PaymentHistoryLoaded(response: response));
    } catch (e) {
      emit(PaymentHistoryError(message: _extractErrorMessage(e)));
    }
  }

  String _extractErrorMessage(Object error) {
    final message = error.toString();
    final regex = RegExp(r'"message"\s*:\s*"([^"]+)"');
    final match = regex.firstMatch(message);

    if (match != null) {
      return match.group(1) ?? 'Operation failed';
    }

    return message.replaceAll('Exception: ', '');
  }

  void _onResetMarkPayment(
    ResetMarkPayment event,
    Emitter<MarkPaymentState> emit,
  ) {
    emit(MarkPaymentInitial());
  }
}
