part of 'class_schedule_bloc.dart';

sealed class ClassScheduleEvent extends Equatable {
  const ClassScheduleEvent();

  @override
  List<Object?> get props => [];
}



class FetchClassScheduleEvent
    extends ClassScheduleEvent {
  final ClassScheduleRequestModel request;

  const FetchClassScheduleEvent(
    this.request,
  );

  @override
  List<Object?> get props => [request];
}

class AddNewDayEvent
    extends ClassScheduleEvent {
  final ClassNewDayRequestModel request;

  const AddNewDayEvent(
    this.request,
  );

  @override
  List<Object?> get props => [request];
}

class UpdateClassScheduleEvent
    extends ClassScheduleEvent {
  final UpdateClassScheduleRequestModel request;

  const UpdateClassScheduleEvent(
    this.request,
  );

  @override
  List<Object?> get props => [request];
}

class CancelClassScheduleEvent
    extends ClassScheduleEvent {
  final ClassCancelRequestModel request;

  const CancelClassScheduleEvent(
    this.request,
  );

  @override
  List<Object?> get props => [request];
}