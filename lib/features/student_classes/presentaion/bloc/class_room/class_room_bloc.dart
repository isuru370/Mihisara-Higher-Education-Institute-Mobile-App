import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/get_class_with_grade_model/get_classes_by_grade_response_model.dart';
import '../../../data/models/store_student_class_enrollment/create_student_request_class_model.dart';
import '../../../data/models/store_student_class_enrollment/create_student_response_class_model.dart';
import '../../../data/models/student_class_enrollment_status_change_model/class_status_request_model.dart';
import '../../../data/models/student_class_enrollment_status_change_model/class_status_response_model.dart';
import '../../../domain/usecase/create_student_class_enrollment_usecase.dart';
import '../../../domain/usecase/get_classes_by_grade_usecase.dart';
import '../../../domain/usecase/toggle_class_status_usecase.dart';

part 'class_room_event.dart';
part 'class_room_state.dart';

class ClassRoomBloc extends Bloc<ClassRoomEvent, ClassRoomState> {
  final GetClassesByGradeUseCase getClassesByGradeUsecase;
  final CreateStudentClassEnrollmentUseCase createStudentClassEnrollmentUsecase;
  final ToggleClassStatusUseCase toggleClassStatusUseCase;

  ClassRoomBloc({
    required this.getClassesByGradeUsecase,
    required this.createStudentClassEnrollmentUsecase,
    required this.toggleClassStatusUseCase,
  }) : super(ClassRoomInitial()) {
    on<LoadClassesByGradeEvent>((event, emit) async {
      emit(ClassRoomLoading());

      try {
        final result = await getClassesByGradeUsecase(
          gradeId: event.gradeId,
        );

        emit(ClassRoomLoaded(result));
      } catch (e) {
        emit(ClassRoomError(e.toString()));
      }
    });

    on<CreateStudentClassEnrollmentEvent>((event, emit) async {
      emit(ClassRoomCreateLoading());

      try {
        final result = await createStudentClassEnrollmentUsecase(
          request: event.request,
        );

        if (result.isSuccess) {
          emit(ClassRoomCreateSuccess(result));
        } else {
          emit(ClassRoomCreateError(result.message ?? 'Enrollment failed'));
        }
      } catch (e) {
        emit(ClassRoomCreateError(e.toString()));
      }
    });

    on<ToggleClassStatusEvent>((event, emit) async {
      emit(ClassRoomStatusToggleLoading());

      try {
        final result = await toggleClassStatusUseCase(
          request: ClassStatusRequestModel(
            studentEnrollmentId: event.enrollmentId,
          ),
        );

        if (result.isSuccess) {
          emit(ClassRoomStatusToggleSuccess(result));
        } else {
          emit(ClassRoomStatusToggleError(result.message));
        }
      } catch (e) {
        emit(ClassRoomStatusToggleError(e.toString()));
      }
    });
  }
}