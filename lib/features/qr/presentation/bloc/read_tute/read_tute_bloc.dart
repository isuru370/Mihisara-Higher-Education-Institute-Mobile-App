import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/read_tute/read_tute_request_model.dart';
import '../../../data/model/read_tute/read_tute_response_model.dart';
import '../../../domain/usecases/read_tute_usecase.dart';

part 'read_tute_event.dart';
part 'read_tute_state.dart';

class ReadTuteBloc extends Bloc<ReadTuteEvent, ReadTuteState> {
  final ReadTuteUseCase readTuteUseCase;

  ReadTuteBloc({required this.readTuteUseCase}) : super(ReadTuteInitial()) {
    on<ReadTuteRequested>(_onReadTuteRequested);
  }

  Future<void> _onReadTuteRequested(
    ReadTuteRequested event,
    Emitter<ReadTuteState> emit,
  ) async {
    emit(ReadTuteLoading());

    try {
      final result = await readTuteUseCase(
        qrCode: event.readTuteRequestModel.qrCode,
      );

      emit(ReadTuteSuccess(response: result));
    } catch (e) {
      emit(ReadTuteFailure(message: e.toString()));
    }
  }
}