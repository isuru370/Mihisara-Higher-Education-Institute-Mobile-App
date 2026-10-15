import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/institute_hall_model.dart';
import '../../../domain/usecase/fetch_institute_hall.dart';

part 'institute_hall_event.dart';
part 'institute_hall_state.dart';

class InstituteHallBloc
    extends Bloc<InstituteHallEvent, InstituteHallState> {

  final FetchInstituteHall fetchInstituteHall;

  InstituteHallBloc({
    required this.fetchInstituteHall,
  }) : super(InstituteHallInitial()) {

    on<LoadInstituteHalls>(_onLoadInstituteHalls);
  }

  Future<void> _onLoadInstituteHalls(
    LoadInstituteHalls event,
    Emitter<InstituteHallState> emit,
  ) async {
    emit(InstituteHallLoading());

    try {
      final response = await fetchInstituteHall();

      emit(
        InstituteHallLoaded(response.data),
      );
    } catch (e) {
      emit(
        InstituteHallError(e.toString()),
      );
    }
  }
}