import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/read_student_classes/read_student_classes_request_model.dart';
import '../../../data/model/read_student_classes/read_student_classes_response_model.dart';
import '../../../domain/usecases/read_student_classes_usecase.dart';

part 'read_student_classes_event.dart';
part 'read_student_classes_state.dart';

class ReadStudentClassesBloc
    extends Bloc<ReadStudentClassesEvent, ReadStudentClassesState> {
  final ReadStudentClassesUseCase readStudentClassesUseCase;

  ReadStudentClassesBloc({required this.readStudentClassesUseCase})
    : super(ReadStudentClassesInitial()) {
    on<ReadStudentClassesRequested>(_onReadStudentClassesRequested);
  }

  Future<void> _onReadStudentClassesRequested(
    ReadStudentClassesRequested event,
    Emitter<ReadStudentClassesState> emit,
  ) async {
    emit(ReadStudentClassesLoading());

    try {
      final response = await readStudentClassesUseCase(
        ReadStudentClassesRequestModel(
          qrCode: event.qrCode,
        ),
      );

      emit(ReadStudentClassesSuccess(response: response));
    } catch (e) {
      emit(ReadStudentClassesError(message: e.toString()));
    }
  }
}
