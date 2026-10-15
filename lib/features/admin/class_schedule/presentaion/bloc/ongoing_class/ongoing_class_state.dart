part of 'ongoing_class_bloc.dart';

sealed class OngoingClassState extends Equatable {
  const OngoingClassState();

  @override
  List<Object?> get props => [];
}

final class OngoingClassInitial extends OngoingClassState {}

final class OngoingClassLoading extends OngoingClassState {}

final class OngoingClassError extends OngoingClassState {
  final String message;
  const OngoingClassError({required this.message});

  @override
  List<Object> get props => [message];
}

final class OngoingClassLoaded extends OngoingClassState {
  final OngoingClassResponseModel response;

  const OngoingClassLoaded(this.response);

  @override
  List<Object?> get props => [response];
}
