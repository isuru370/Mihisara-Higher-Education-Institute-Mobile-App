part of 'class_room_bloc.dart';

sealed class ClassRoomState extends Equatable {
  const ClassRoomState();

  @override
  List<Object?> get props => [];
}

final class ClassRoomInitial extends ClassRoomState {}

final class ClassRoomLoading extends ClassRoomState {}

final class ClassRoomLoaded extends ClassRoomState {
  final GetClassesByGradeResponseModel response;

  const ClassRoomLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

final class ClassRoomError extends ClassRoomState {
  final String message;

  const ClassRoomError(this.message);

  @override
  List<Object?> get props => [message];
}

final class ClassRoomCreateLoading extends ClassRoomState {}

final class ClassRoomCreateSuccess extends ClassRoomState {
  final CreateStudentClassResponseModel response;

  const ClassRoomCreateSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

final class ClassRoomCreateError extends ClassRoomState {
  final String message;

  const ClassRoomCreateError(this.message);

  @override
  List<Object?> get props => [message];
}

final class ClassRoomStatusToggleLoading extends ClassRoomState {}

final class ClassRoomStatusToggleSuccess extends ClassRoomState {
  final ClassStatusResponseModel response;

  const ClassRoomStatusToggleSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

final class ClassRoomStatusToggleError extends ClassRoomState {
  final String message;

  const ClassRoomStatusToggleError(this.message);

  @override
  List<Object?> get props => [message];
}
