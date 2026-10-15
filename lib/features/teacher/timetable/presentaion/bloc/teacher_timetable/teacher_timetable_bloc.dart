import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/teacher_timetable_model.dart';
import '../../../domain/usecase/get_teacher_timetable.dart';


part 'teacher_timetable_event.dart';
part 'teacher_timetable_state.dart';

class TeacherTimetableBloc
    extends Bloc<TeacherTimetableEvent, TeacherTimetableState> {
  final GetTeacherTimetable getTeacherTimetable;

  TeacherTimetableBloc({
    required this.getTeacherTimetable,
  }) : super(TeacherTimetableInitial()) {
    on<FetchTeacherTimetable>(_onFetchTeacherTimetable);
  }

  Future<void> _onFetchTeacherTimetable(
    FetchTeacherTimetable event,
    Emitter<TeacherTimetableState> emit,
  ) async {
    emit(TeacherTimetableLoading());

    try {
      final timetable = await getTeacherTimetable(
        date: event.date,
      );

      emit(
        TeacherTimetableLoaded(
          timetable: timetable,
        ),
      );
    } catch (e) {
      emit(
        TeacherTimetableError(
          message: e.toString().replaceFirst(
                'Exception: ',
                '',
              ),
        ),
      );
    }
  }
}