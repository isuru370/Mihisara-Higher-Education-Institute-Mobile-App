part of 'institute_hall_bloc.dart';

sealed class InstituteHallEvent extends Equatable {
  const InstituteHallEvent();

  @override
  List<Object> get props => [];
}

final class LoadInstituteHalls extends InstituteHallEvent {
  const LoadInstituteHalls();
}