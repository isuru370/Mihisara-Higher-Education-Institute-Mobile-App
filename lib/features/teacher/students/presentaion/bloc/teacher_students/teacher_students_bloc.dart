import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/teacher_students_model.dart';
import '../../../domain/usecase/get_teacher_students.dart';
import '../../../../../../core/errors/error_message.dart';



part 'teacher_students_event.dart';
part 'teacher_students_state.dart';

class TeacherStudentsBloc
    extends Bloc<TeacherStudentsEvent, TeacherStudentsState> {
  final GetTeacherStudents getTeacherStudents;

  TeacherStudentsBloc({
    required this.getTeacherStudents,
  }) : super(TeacherStudentsInitial()) {
    on<FetchTeacherStudents>(_onFetchTeacherStudents);
  }

  Future<void> _onFetchTeacherStudents(
    FetchTeacherStudents event,
    Emitter<TeacherStudentsState> emit,
  ) async {
    emit(TeacherStudentsLoading());

    try {
      final result = await getTeacherStudents(
        classId: event.classId,
      );

      emit(
        TeacherStudentsLoaded(
          data: result,
        ),
      );
    } catch (e) {
      emit(
        TeacherStudentsError(
          message: friendlyError(e),
        ),
      );
    }
  }
}