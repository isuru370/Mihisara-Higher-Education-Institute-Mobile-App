part of 'institute_hall_bloc.dart';

sealed class InstituteHallState extends Equatable {
  const InstituteHallState();

  @override
  List<Object> get props => [];
}

final class InstituteHallInitial extends InstituteHallState {}

final class InstituteHallLoading extends InstituteHallState {}

final class InstituteHallLoaded extends InstituteHallState {
  final List<InstituteHallModel> halls;

  const InstituteHallLoaded(this.halls);

  @override
  List<Object> get props => [halls];
}

final class InstituteHallError extends InstituteHallState {
  final String message;

  const InstituteHallError(this.message);

  @override
  List<Object> get props => [message];
}
