import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/scan_attendance_new/scan_attendance_request_model.dart';
import '../../../data/model/scan_attendance_new/scan_attendance_response_model.dart';
import '../../../domain/usecases/scan_attendance_usecase.dart';

part 'scan_attendance_event.dart';
part 'scan_attendance_state.dart';

class ScanAttendanceBloc
    extends Bloc<ScanAttendanceEvent, ScanAttendanceState> {
  final ScanAttendanceUsecase scanAttendanceUseCase;

  ScanAttendanceBloc({required this.scanAttendanceUseCase}) : super(ScanAttendanceInitial()) {
    on<ScanAttendanceRequested>(_onScanAttendance);

    on<ScanAttendanceReset>((event, emit) {
      emit(ScanAttendanceInitial());
    });
  }

  Future<void> _onScanAttendance(
    ScanAttendanceRequested event,

    Emitter<ScanAttendanceState> emit,
  ) async {
    emit(ScanAttendanceLoading());

    try {
      final response = await scanAttendanceUseCase(
        requestModel: ScanAttendanceRequestModel(qrCode: event.qrCode),
      );

      emit(ScanAttendanceSuccess(response: response));
    } catch (e) {
      emit(ScanAttendanceFailure(message: e.toString()));
    }
  }
}
