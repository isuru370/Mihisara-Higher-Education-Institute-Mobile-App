import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/today_class_item_model.dart';
import '../../../domain/usecase/get_today_classes_usecase.dart';


part 'today_classes_event.dart';
part 'today_classes_state.dart';

class TodayClassesBloc
    extends Bloc<TodayClassesEvent, TodayClassesState> {
  final GetTodayClassesUseCase getTodayClassesUseCase;

  TodayClassesBloc({
    required this.getTodayClassesUseCase,
  }) : super(TodayClassesInitial()) {
    on<FetchTodayClassesEvent>(_onFetchTodayClasses);
  }

  Future<void> _onFetchTodayClasses(
    FetchTodayClassesEvent event,
    Emitter<TodayClassesState> emit,
  ) async {
    emit(TodayClassesLoading());

    try {
      final response = await getTodayClassesUseCase();

      emit(TodayClassesLoaded(response.data));
    } catch (e) {
      emit(TodayClassesError(e.toString()));
    }
  }
}