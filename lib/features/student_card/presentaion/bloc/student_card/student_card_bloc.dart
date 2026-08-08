import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/assignment/assignment_card_request_model.dart';
import '../../../data/model/assignment/assignment_card_response_model.dart';
import '../../../data/model/assignment/assignment_search_student_response_model.dart';
import '../../../data/model/re_assign/re_assign_request_model.dart';
import '../../../data/model/re_assign/re_assign_response_model.dart';
import '../../../data/model/student_card_request_model.dart';
import '../../../data/model/student_card_response_model.dart';
import '../../../domain/usecase/assign_student_card_usecase.dart';
import '../../../domain/usecase/re_assign_student_card_usecase.dart';
import '../../../domain/usecase/scan_student_card_usecase.dart';
import '../../../domain/usecase/search_student_assignment_usecase.dart';

part 'student_card_event.dart';
part 'student_card_state.dart';

class StudentCardBloc extends Bloc<StudentCardEvent, StudentCardState> {
  final ScanStudentCardUsecase scanStudentCardUsecase;
  final ReAssignStudentCardUsecase reAssignStudentCardUsecase;
  final SearchStudentAssignmentUsecase searchStudentAssignmentUsecase;
  final AssignStudentCardUsecase assignStudentCardUsecase;

  StudentCardBloc({
    required this.scanStudentCardUsecase,
    required this.reAssignStudentCardUsecase,
    required this.searchStudentAssignmentUsecase,
    required this.assignStudentCardUsecase,
  }) : super(StudentCardInitial()) {
    on<ScanStudentCardEvent>(_onScanStudentCard);
    on<ReAssignStudentCardEvent>(_onReAssignStudentCard);
    on<SearchStudentForAssignmentEvent>(_onSearchStudentForAssignment);
    on<AssignStudentCardEvent>(_onAssignStudentCard);
  }

  Future<void> _onScanStudentCard(
    ScanStudentCardEvent event,
    Emitter<StudentCardState> emit,
  ) async {
    emit(StudentCardLoading());

    try {
      final response = await scanStudentCardUsecase.execute(event.request);

      emit(StudentCardLoaded(response));
    } catch (e) {
      emit(StudentCardError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onReAssignStudentCard(
    ReAssignStudentCardEvent event,
    Emitter<StudentCardState> emit,
  ) async {
    emit(StudentCardLoading());

    try {
      final response = await reAssignStudentCardUsecase.execute(event.request);

      emit(ReAssignStudentCardLoaded(response));
    } catch (e) {
      emit(StudentCardError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onSearchStudentForAssignment(
    SearchStudentForAssignmentEvent event,
    Emitter<StudentCardState> emit,
  ) async {
    emit(StudentCardLoading());

    try {
      final response = await searchStudentAssignmentUsecase.execute(
        event.request,
      );

      emit(SearchStudentForAssignmentLoaded(response));
    } catch (e) {
      emit(StudentCardError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onAssignStudentCard(
    AssignStudentCardEvent event,
    Emitter<StudentCardState> emit,
  ) async {
    emit(StudentCardLoading());

    try {
      final response = await assignStudentCardUsecase.execute(event.request);

      emit(AssignStudentCardLoaded(response));
    } catch (e) {
      emit(StudentCardError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
