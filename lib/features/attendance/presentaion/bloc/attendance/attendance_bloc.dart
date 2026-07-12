import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/atendance_request_model.dart';
import '../../../data/models/attendance_history/attendance_history_request_model.dart';
import '../../../data/models/attendance_history/attendance_history_response_model.dart';
import '../../../data/models/attendance_report/attendance_report_request_model.dart';
import '../../../data/models/attendance_report/attendance_report_response_model.dart';
import '../../../data/models/attendance_response_model.dart';
import '../../../domain/usecases/get_attendance_history_usecase.dart';
import '../../../domain/usecases/get_attendance_report_usecase.dart';
import '../../../domain/usecases/mark_attendance_usecase.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final MarkAttendanceUseCase markAttendanceUseCase;
  final GetAttendanceHistoryUseCase getAttendanceHistoryUseCase;
  final GetAttendanceReportUseCase getAttendanceReportUseCase;

  AttendanceBloc({
    required this.markAttendanceUseCase,
    required this.getAttendanceHistoryUseCase,
    required this.getAttendanceReportUseCase,
  }) : super(AttendanceInitial()) {
    on<MarkAttendanceRequested>(_onMarkAttendanceRequested);
    on<AttendanceHistoryRequested>(_onAttendanceHistoryRequested);
    on<AttendanceReportRequested>(_onAttendanceReportRequested);
  }

  Future<void> _onMarkAttendanceRequested(
    MarkAttendanceRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());

    try {
      final result = await markAttendanceUseCase(request: event.request);

      emit(AttendanceSuccess(message: result.message, response: result));
    } catch (e) {
      emit(AttendanceError(message: _extractErrorMessage(e)));
    }
  }

  Future<void> _onAttendanceHistoryRequested(
    AttendanceHistoryRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceHistoryLoading());

    try {
      final result = await getAttendanceHistoryUseCase(request: event.request);

      emit(AttendanceHistoryLoaded(response: result));
    } catch (e) {
      emit(AttendanceHistoryError(message: _extractErrorMessage(e)));
    }
  }
  Future<void> _onAttendanceReportRequested(
    AttendanceReportRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceReportLoading());

    try {
      final result = await getAttendanceReportUseCase.execute(
        request: AttendanceReportRequestModel(
          scheduleId: event.scheduleId,
        ),
      );

      emit(AttendanceReportLoaded(response: result));
    } catch (e) {
      emit(AttendanceReportError(message: _extractErrorMessage(e)));
    }
  }

  String _extractErrorMessage(Object error) {
    final message = error.toString();
    final regex = RegExp(r'"message"\s*:\s*"([^"]+)"');
    final match = regex.firstMatch(message);

    if (match != null) {
      return match.group(1) ?? 'Operation failed';
    }

    return message.replaceAll('Exception: ', '');
  }
}
