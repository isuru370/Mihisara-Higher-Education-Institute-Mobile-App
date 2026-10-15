part of 'read_tute_bloc.dart';

sealed class ReadTuteEvent extends Equatable {
  const ReadTuteEvent();

  @override
  List<Object?> get props => [];
}

class ReadTuteRequested extends ReadTuteEvent {
  final ReadTuteRequestModel readTuteRequestModel;

  const ReadTuteRequested({
    required this.readTuteRequestModel,
  });

  @override
  List<Object?> get props => [readTuteRequestModel];
}