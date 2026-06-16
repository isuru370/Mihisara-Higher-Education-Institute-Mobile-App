part of 'tute_bloc.dart';

sealed class TuteState extends Equatable {
  const TuteState();

  @override
  List<Object?> get props => [];
}

final class TuteInitial extends TuteState {}

final class TuteLoading extends TuteState {}

final class TuteLoaded extends TuteState {
  final List<StudentTuteModel> tutes;

  const TuteLoaded(this.tutes);

  @override
  List<Object?> get props => [tutes];
}

final class TuteError extends TuteState {
  final String message;

  const TuteError(this.message);

  @override
  List<Object?> get props => [message];
}

final class TuteCreateSuccess extends TuteState {
  final String message;

  const TuteCreateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
