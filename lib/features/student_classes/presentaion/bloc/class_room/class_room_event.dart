part of 'class_room_bloc.dart';

sealed class ClassRoomEvent extends Equatable {
  const ClassRoomEvent();

  @override
  List<Object> get props => [];
}

class LoadClassesByGradeEvent extends ClassRoomEvent {
  final String gradeId;

  const LoadClassesByGradeEvent({
    required this.gradeId,
  });

  @override
  List<Object> get props => [gradeId];
}

class CreateStudentClassEnrollmentEvent extends ClassRoomEvent {
  final CreateStudentClassRequestModel request;

  const CreateStudentClassEnrollmentEvent({
    required this.request,
  });

  @override
  List<Object> get props => [request];
}

class ToggleClassStatusEvent extends ClassRoomEvent {
  final int enrollmentId;

  const ToggleClassStatusEvent({
    required this.enrollmentId,
  });

  @override
  List<Object> get props => [enrollmentId];
}