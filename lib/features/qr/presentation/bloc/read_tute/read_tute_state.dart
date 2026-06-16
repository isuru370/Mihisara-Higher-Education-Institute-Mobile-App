part of 'read_tute_bloc.dart';

sealed class ReadTuteState extends Equatable {
  const ReadTuteState();

  @override
  List<Object?> get props => [];
}

final class ReadTuteInitial extends ReadTuteState {}

final class ReadTuteLoading extends ReadTuteState {}

final class ReadTuteSuccess extends ReadTuteState {
  final ReadTuteResponseModel response;

  const ReadTuteSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class ReadTuteFailure extends ReadTuteState {
  final String message;

  const ReadTuteFailure({required this.message});

  @override
  List<Object?> get props => [message];
}