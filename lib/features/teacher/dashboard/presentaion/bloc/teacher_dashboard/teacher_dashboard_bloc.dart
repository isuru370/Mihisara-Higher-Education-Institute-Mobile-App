import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/teacher_dashboard_model.dart';
import '../../../domain/repositories/usecases/get_teacher_dashboard.dart';

part 'teacher_dashboard_event.dart';
part 'teacher_dashboard_state.dart';

class TeacherDashboardBloc
    extends Bloc<TeacherDashboardEvent, TeacherDashboardState> {
  final GetTeacherDashboard getTeacherDashboard;

  TeacherDashboardBloc({required this.getTeacherDashboard})
    : super(TeacherDashboardInitial()) {
    on<FetchTeacherDashboard>(_onFetchTeacherDashboard);
  }

  Future<void> _onFetchTeacherDashboard(
    FetchTeacherDashboard event,
    Emitter<TeacherDashboardState> emit,
  ) async {
    emit(TeacherDashboardLoading());

    try {
      final dashboard = await getTeacherDashboard();

      emit(TeacherDashboardSuccess(dashboard: dashboard));
    } catch (e) {
      emit(TeacherDashboardFailure(message: e.toString()));
    }
  }
}
