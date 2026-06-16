import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/read_attendance/read_attendance_data_model.dart';
import '../../../data/model/read_attendance/read_attendance_request_model.dart';
import '../../../domain/usecases/read_attendance_usecase.dart';

part 'read_attendance_event.dart';
part 'read_attendance_state.dart';

class ReadAttendanceBloc
    extends Bloc<ReadAttendanceEvent, ReadAttendanceState> {
  final ReadAttendanceUseCase readAttendanceUseCase;

  ReadAttendanceBloc({required this.readAttendanceUseCase})
      : super(ReadAttendanceInitial()) {
    on<ReadAttendanceRequested>(_onReadAttendanceRequested);
  }

  Future<void> _onReadAttendanceRequested(
    ReadAttendanceRequested event,
    Emitter<ReadAttendanceState> emit,
  ) async {
    emit(ReadAttendanceLoading());

    try {
      final result = await readAttendanceUseCase(
        requestModel: ReadAttendanceRequestModel(
          qrCode: event.qrCode,
          studentClassId: event.studentClassId,
          classCategoryFeeId: event.classCategoryFeeId,
        ),
      );

      emit(
        ReadAttendanceLoaded(
          data: result.data,
        ),
      );
    } catch (e) {
      emit(ReadAttendanceError(e.toString()));
    }
  }
}