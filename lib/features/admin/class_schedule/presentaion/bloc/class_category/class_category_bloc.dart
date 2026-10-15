import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/class_categry/class_category_request_model.dart';
import '../../../data/model/class_categry/class_category_response_model.dart';
import '../../../domain/usecase/fetch_class_category_usecase.dart';

part 'class_category_event.dart';
part 'class_category_state.dart';

class ClassCategoryBloc
    extends Bloc<
        ClassCategoryEvent,
        ClassCategoryState> {

  final FetchClassCategoryUseCase
      fetchClassCategoryUseCase;

  ClassCategoryBloc({
    required this.fetchClassCategoryUseCase,
  }) : super(ClassCategoryInitial()) {

    on<FetchClassCategoryEvent>(
      _onFetchClassCategory,
    );
  }

  Future<void> _onFetchClassCategory(
    FetchClassCategoryEvent event,
    Emitter<ClassCategoryState> emit,
  ) async {
    try {
      emit(ClassCategoryLoading());

      final response =
          await fetchClassCategoryUseCase(
        event.request,
      );

      emit(
        ClassCategoryLoaded(
          response,
        ),
      );
    } catch (e) {
      emit(
        ClassCategoryError(
          message: e.toString(),
        ),
      );
    }
  }
}