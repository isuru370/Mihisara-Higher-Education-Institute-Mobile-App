import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/student_image_model.dart';
import '../../../data/model/student_image_update/student_image_response_model.dart';

import '../../../domain/usecase/fetch_student_image_usecase.dart';
import '../../../domain/usecase/update_student_image_usecase.dart';

part 'student_image_event.dart';
part 'student_image_state.dart';

class StudentImageBloc
    extends Bloc<StudentImageEvent, StudentImageState> {

  final FetchStudentImageUsecase
      fetchStudentImageUsecase;

  final UpdateStudentImageUsecase
      updateStudentImageUsecase;

  StudentImageBloc({
    required this.fetchStudentImageUsecase,
    required this.updateStudentImageUsecase,
  }) : super(StudentImageInitial()) {

    on<FetchStudentImageEvent>(
      _onFetchStudentImage,
    );

    on<UpdateStudentImageEvent>(
      _onUpdateStudentImage,
    );
  }

  // FETCH
  Future<void> _onFetchStudentImage(
    FetchStudentImageEvent event,
    Emitter<StudentImageState> emit,
  ) async {

    emit(StudentImageLoading());

    try {

      final response =
          await fetchStudentImageUsecase();

      emit(
        StudentImageLoaded(
          students: response.data,
        ),
      );

    } catch (e) {

      emit(
        StudentImageError(
          message: e.toString(),
        ),
      );
    }
  }

  // UPDATE
  Future<void> _onUpdateStudentImage(
    UpdateStudentImageEvent event,
    Emitter<StudentImageState> emit,
  ) async {

    try {

      emit(StudentImageUpdating());

      final request =
          StudentImageUpdateRequestModel(
        studentId: event.studentId,
        quickImageId: event.quickImageId,
      );

      final response =
          await updateStudentImageUsecase(
        request,
      );

      emit(
        StudentImageUpdateSuccess(
          message: response.message,
        ),
      );

      // reload students
      final studentResponse =
          await fetchStudentImageUsecase();

      emit(
        StudentImageLoaded(
          students: studentResponse.data,
        ),
      );

    } catch (e) {

      emit(
        StudentImageError(
          message: e.toString(),
        ),
      );
    }
  }
}