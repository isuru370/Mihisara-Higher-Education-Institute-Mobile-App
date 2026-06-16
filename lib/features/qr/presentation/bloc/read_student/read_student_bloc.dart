import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../students/data/models/student_search_model/read_student_response_model.dart';
import '../../../../students/domain/usecases/read_student_usecase.dart';

part 'read_student_event.dart';
part 'read_student_state.dart';

class ReadStudentBloc extends Bloc<ReadStudentEvent, ReadStudentState> {
  final ReadStudentUsecase readStudentUseCase;
  ReadStudentBloc({required this.readStudentUseCase})
    : super(ReadStudentInitial()) {
    on<ReadStudentRequested>(_onReadStudentRequested);
  }
  Future<void> _onReadStudentRequested(
    ReadStudentRequested event,
    Emitter<ReadStudentState> emit,
  ) async {
    emit(ReadStudentLoading());

    try {
      final result = await readStudentUseCase(qrCode: event.qrCode);
      emit(ReadStudentLoaded(response: result));
    } catch (e) {
      emit(ReadStudentError(e.toString()));
    }
  }
}
