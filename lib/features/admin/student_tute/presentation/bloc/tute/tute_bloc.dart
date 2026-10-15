import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/fetch_tute/fetch_tute_request_model.dart';
import '../../../data/model/fetch_tute/student_tute_model.dart';
import '../../../domain/usecase/create_tute_usecase.dart';
import '../../../domain/usecase/get_student_history_tute_usecase.dart';

part 'tute_event.dart';
part 'tute_state.dart';

class TuteBloc extends Bloc<TuteEvent, TuteState> {
  final GetStudentTuteHistoryUseCase getStudentTuteHistoryUseCase;
  final CreateTuteUseCase createTuteUseCase;

  TuteBloc({
    required this.getStudentTuteHistoryUseCase,
    required this.createTuteUseCase,
  }) : super(TuteInitial()) {
    on<LoadAllTuteEvent>(_onLoadAllTute);
    on<CreateTuteEvent>(_onCreateTute);
  }

  Future<void> _onCreateTute(
    CreateTuteEvent event,
    Emitter<TuteState> emit,
  ) async {
    emit(TuteLoading());

    try {
      final response = await createTuteUseCase(
        studentId: event.studentId,
        studentClassEnrollmentId: event.studentClassEnrollmentId,
        issuedMonth: event.issuedMonth,
        isIssued: event.isIssued,
        issuedAt: event.issuedAt,

        note: event.note,
      );

      emit(TuteCreateSuccess(response.message));
    } catch (e) {
      emit(TuteError(e.toString()));
    }
  }

  Future<void> _onLoadAllTute(
  LoadAllTuteEvent event,
  Emitter<TuteState> emit,
) async {
  emit(TuteLoading());

  try {
    final response = await getStudentTuteHistoryUseCase(
      event.fetchStudentTuteRequestModel.studentId,
      event.fetchStudentTuteRequestModel.enrollmentId,
    );

    emit(TuteLoaded(response.data));
  } catch (e) {
    emit(TuteError(e.toString()));
  }
}
}
