import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/ongoing/ongoing_class_response_model.dart';
import '../../../domain/usecase/fetch_ongoing_class_usecase.dart';

part 'ongoing_class_event.dart';
part 'ongoing_class_state.dart';

class OngoingClassBloc extends Bloc<OngoingClassEvent, OngoingClassState> {
  final FetchOngoingClassUseCase fetchOngoingClassUseCase;

  OngoingClassBloc({required this.fetchOngoingClassUseCase})
    : super(OngoingClassInitial()) {
    on<FetchOngoingClassEvent>(_onFetchOngoingClass);
  }

  Future<void> _onFetchOngoingClass(
    FetchOngoingClassEvent event,
    Emitter<OngoingClassState> emit,
  ) async {
    try {
      emit(OngoingClassLoading());

      final response = await fetchOngoingClassUseCase();

      emit(OngoingClassLoaded(response));
    } catch (e) {
      emit(OngoingClassError(message: e.toString()));
    }
  }
}
