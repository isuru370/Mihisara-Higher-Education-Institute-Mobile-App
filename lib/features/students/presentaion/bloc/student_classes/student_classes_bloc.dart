import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/student_classes_model/student_class_response_model.dart';
import '../../../data/models/student_classes_model/student_request_model.dart';
import '../../../domain/usecases/student_classes_usecase.dart';

part 'student_classes_event.dart';
part 'student_classes_state.dart';

class StudentClassesBloc
    extends Bloc<StudentClassesEvent, StudentClassesState> {
  final StudentClassesUsecase studentClassesUsecase;

  StudentClassesBloc({
    required this.studentClassesUsecase,
  }) : super(StudentClassesInitial()) {
    on<FetchStudentClasses>(_onFetchStudentClasses);
  }

  Future<void> _onFetchStudentClasses(
    FetchStudentClasses event,
    Emitter<StudentClassesState> emit,
  ) async {
    emit(StudentClassesLoading());

    try {
      final request = StudentRequestModel(studentId: event.studentId);

      // Use the usecase instead of calling repository directly
      final response = await studentClassesUsecase.execute(request);

      emit(StudentClassesLoaded(response: response));
    } catch (e) {
      emit(StudentClassesError(e.toString()));
    }
  }
}
