import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/app_exceptions.dart';
import '../../../data/models/create_student/create_student_response_model.dart';
import '../../../data/models/student_custom_ids/student_custom_id_model.dart';
import '../../../data/models/student_custom_ids/students_custom_id_request_model.dart';
import '../../../data/models/students_model.dart';
import '../../../domain/usecases/create_student_usecase.dart';
import '../../../domain/usecases/get_students_custom_id_usecase.dart';
import '../../../domain/usecases/students_usecase.dart';

part 'students_event.dart';
part 'students_state.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  final CreateStudentUsecase createStudentUsecase;
  final GetStudentsUseCase getStudentsUseCase;
  final GetStudentsCustomIdUsecase getStudentsCustomIdUsecase;

  StudentsBloc({
    required this.createStudentUsecase,
    required this.getStudentsUseCase,
    required this.getStudentsCustomIdUsecase,
  }) : super(StudentsInitial()) {
    on<CreateStudentEvent>(_onCreateStudent);
    on<FetchStudents>(_onFetchStudents);
    on<FetchStudentCustomIds>(_onFetchStudentCustomIds); // ✅ NEW
  }

  Future<void> _onCreateStudent(
    CreateStudentEvent event,
    Emitter<StudentsState> emit,
  ) async {
    emit(StudentsLoading());

    try {
      final response = await createStudentUsecase.execute(
        student: event.student,
      );

      emit(
        StudentsCreated(
          response: response,
          message: 'Student created successfully',
        ),
      );
    } on AppException catch (e) {
      emit(StudentsError(e.message));
    } catch (_) {
      emit(const StudentsError('Something went wrong'));
    }
  }

  Future<void> _onFetchStudents(
    FetchStudents event,
    Emitter<StudentsState> emit,
  ) async {
    emit(StudentsLoading());

    try {
      final response = await getStudentsUseCase.execute();

      emit(StudentsLoaded(response.students));
    } on AppException catch (e) {
      emit(StudentsError(e.message));
    } catch (_) {
      emit(const StudentsError('Something went wrong'));
    }
  }

  // ===============================
  // CUSTOM ID FETCH (Search + Month)
  // ===============================
  Future<void> _onFetchStudentCustomIds(
    FetchStudentCustomIds event,
    Emitter<StudentsState> emit,
  ) async {
    emit(StudentsLoading());

    try {
      final response = await getStudentsCustomIdUsecase.execute(
        StudentsCustomIdRequestModel(search: event.search, month: event.month),
      );

      emit(StudentCustomIdLoaded(response.studentCustomIds));
    } on AppException catch (e) {
      emit(StudentsError(e.message));
    } catch (_) {
      emit(const StudentsError('Something went wrong'));
    }
  }
}
