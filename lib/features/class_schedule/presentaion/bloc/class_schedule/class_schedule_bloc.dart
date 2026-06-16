import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/cancel/class_cancel_request_model.dart';
import '../../../data/model/cancel/class_cancel_response_model.dart';
import '../../../data/model/newday/class_new_day_request_model.dart';
import '../../../data/model/newday/class_new_day_response_model.dart';
import '../../../data/model/schedule/class_schedule_request_model.dart';
import '../../../data/model/schedule/class_schedule_response_model.dart';
import '../../../data/model/update/update_class_schedule_request_model.dart';
import '../../../data/model/update/update_class_schedule_response_model.dart';
import '../../../domain/usecase/add_new_day_usecase.dart';
import '../../../domain/usecase/cancel_class_schedule_usecase.dart';
import '../../../domain/usecase/fetch_class_schedule_usecase.dart';
import '../../../domain/usecase/update_class_schedule_usecase.dart';

part 'class_schedule_event.dart';
part 'class_schedule_state.dart';

class ClassScheduleBloc extends Bloc<ClassScheduleEvent, ClassScheduleState> {
  
  final FetchClassScheduleUseCase fetchClassScheduleUseCase;
  final AddNewDayUseCase addNewDayUseCase;
  final UpdateClassScheduleUseCase updateClassScheduleUseCase;
  final CancelClassScheduleUseCase cancelClassScheduleUseCase;

  ClassScheduleBloc({
   
    required this.fetchClassScheduleUseCase,
    required this.addNewDayUseCase,
    required this.updateClassScheduleUseCase,
    required this.cancelClassScheduleUseCase,
  }) : super(ClassScheduleInitial()) {
    
    on<FetchClassScheduleEvent>(_onFetchClassSchedule);
    on<AddNewDayEvent>(_onAddNewDay);
    on<UpdateClassScheduleEvent>(_onUpdateSchedule);
    on<CancelClassScheduleEvent>(_onCancelSchedule);
  }

  

  Future<void> _onFetchClassSchedule(
    FetchClassScheduleEvent event,
    Emitter<ClassScheduleState> emit,
  ) async {
    try {
      emit(ClassScheduleLoading());

      final response = await fetchClassScheduleUseCase(event.request);

      emit(ClassScheduleLoaded(response));
    } catch (e) {
      emit(ClassScheduleError(e.toString()));
    }
  }

  Future<void> _onAddNewDay(
    AddNewDayEvent event,
    Emitter<ClassScheduleState> emit,
  ) async {
    try {
      emit(ClassScheduleLoading());

      final response = await addNewDayUseCase(event.request);

      emit(AddNewDaySuccess(response));
    } catch (e) {
      emit(ClassScheduleError(e.toString()));
    }
  }

  Future<void> _onUpdateSchedule(
    UpdateClassScheduleEvent event,
    Emitter<ClassScheduleState> emit,
  ) async {
    try {
      emit(ClassScheduleLoading());

      final response = await updateClassScheduleUseCase(event.request);

      emit(UpdateClassScheduleSuccess(response));
    } catch (e) {
      emit(ClassScheduleError(e.toString()));
    }
  }

  Future<void> _onCancelSchedule(
    CancelClassScheduleEvent event,
    Emitter<ClassScheduleState> emit,
  ) async {
    try {
      emit(ClassScheduleLoading());

      final response = await cancelClassScheduleUseCase(event.request);

      emit(CancelClassScheduleSuccess(response));
    } catch (e) {
      emit(ClassScheduleError(e.toString()));
    }
  }
}
