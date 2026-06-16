import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexorait_education_app/features/student_grade/data/models/student_grade_model.dart';

import '../../../domain/usecases/student_grade_usecase.dart';

part 'student_grade_event.dart';
part 'student_grade_state.dart';

class StudentGradeBloc extends Bloc<StudentGradeEvent, StudentGradeState> {
  final StudentGradeUsecase studentGradeUsecase;

  StudentGradeBloc({required this.studentGradeUsecase})
      : super(StudentGradeInitial()) {
    on<GetStudentGradesEvent>(_getStudentGrades);
  }

  Future<void> _getStudentGrades(
    GetStudentGradesEvent event,
    Emitter<StudentGradeState> emit,
  ) async {
    emit(StudentGradeLoading());

    try {
      final response = await studentGradeUsecase.execute();

      emit(StudentGradeLoaded(response.studentGradeList));
    } catch (e) {
      emit(StudentGradeError(e.toString()));
    }
  }
}
