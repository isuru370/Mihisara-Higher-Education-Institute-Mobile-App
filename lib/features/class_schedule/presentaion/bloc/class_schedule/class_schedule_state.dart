part of 'class_schedule_bloc.dart';

sealed class ClassScheduleState extends Equatable {
  const ClassScheduleState();

  @override
  List<Object?> get props => [];
}

final class ClassScheduleInitial extends ClassScheduleState {}

final class ClassScheduleLoading extends ClassScheduleState {}



final class ClassScheduleLoaded extends ClassScheduleState {
  final ClassScheduleResponseModel response;

  const ClassScheduleLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

final class AddNewDaySuccess extends ClassScheduleState {
  final ClassNewDayResponseModel response;

  const AddNewDaySuccess(this.response);

  @override
  List<Object?> get props => [response];
}

final class UpdateClassScheduleSuccess extends ClassScheduleState {
  final UpdateClassScheduleResponseModel response;

  const UpdateClassScheduleSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

final class CancelClassScheduleSuccess extends ClassScheduleState {
  final ClassCancelResponseModel response;

  const CancelClassScheduleSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

final class ClassScheduleError extends ClassScheduleState {
  final String message;

  const ClassScheduleError(this.message);

  @override
  List<Object?> get props => [message];
}
