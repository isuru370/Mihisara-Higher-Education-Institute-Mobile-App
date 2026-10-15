import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/teacher_classes_model.dart';
import '../../../domain/usecase/get_teacher_classes.dart';

part 'teacher_classes_event.dart';
part 'teacher_classes_state.dart';

class TeacherClassesBloc
    extends Bloc<TeacherClassesEvent, TeacherClassesState> {
  final GetTeacherClasses getTeacherClasses;

  TeacherClassesBloc({required this.getTeacherClasses})
    : super(TeacherClassesInitial()) {
    on<FetchTeacherClasses>(_onFetchTeacherClasses);
  }

  Future<void> _onFetchTeacherClasses(
    FetchTeacherClasses event,
    Emitter<TeacherClassesState> emit,
  ) async {
    emit(TeacherClassesLoading());

    try {
      final classes = await getTeacherClasses();

      emit(TeacherClassesLoaded(classes: classes));
    } catch (e) {
      emit(
        TeacherClassesError(
          message: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
