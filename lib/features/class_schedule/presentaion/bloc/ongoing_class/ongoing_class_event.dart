part of 'ongoing_class_bloc.dart';

sealed class OngoingClassEvent extends Equatable {
  const OngoingClassEvent();

  @override
  List<Object> get props => [];
}

class FetchOngoingClassEvent extends OngoingClassEvent {}
