import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/daily_attendance_details_request_model.dart';
import '../../../data/model/daily_attendance_details_response_model.dart';
import '../../../domain/usecase/get_daily_attendance_details_usecase.dart';


part 'daily_attendance_details_event.dart';
part 'daily_attendance_details_state.dart';

class DailyAttendanceDetailsBloc extends Bloc<
    DailyAttendanceDetailsEvent,
    DailyAttendanceDetailsState> {

  final GetDailyAttendanceDetailsUseCase getDailyAttendanceDetailsUseCase;

  DailyAttendanceDetailsBloc({required this.getDailyAttendanceDetailsUseCase})
      : super(DailyAttendanceDetailsInitial()) {

    on<LoadDailyAttendanceDetailsEvent>(
      _onLoadDailyAttendanceDetails,
    );
  }

  Future<void> _onLoadDailyAttendanceDetails(
    LoadDailyAttendanceDetailsEvent event,
    Emitter<DailyAttendanceDetailsState> emit,
  ) async {

    emit(DailyAttendanceDetailsLoading());

    try {
      final result = await getDailyAttendanceDetailsUseCase(
        token: event.token,
        request: event.request,
      );

      emit(DailyAttendanceDetailsLoaded(result));

    } catch (e) {
      emit(DailyAttendanceDetailsError(e.toString()));
    }
  }
}
