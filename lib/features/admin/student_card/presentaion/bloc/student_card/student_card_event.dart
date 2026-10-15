part of 'student_card_bloc.dart';

sealed class StudentCardEvent extends Equatable {
  const StudentCardEvent();

  @override
  List<Object?> get props => [];
}

final class ScanStudentCardEvent extends StudentCardEvent {
  final StudentCardRequestModel request;

  const ScanStudentCardEvent({
    required this.request,
  });

  @override
  List<Object?> get props => [request];
}

final class ReAssignStudentCardEvent extends StudentCardEvent {
  final ReAssignRequestModel request;

  const ReAssignStudentCardEvent({
    required this.request,
  });

  @override
  List<Object?> get props => [request];
}

class SearchStudentForAssignmentEvent extends StudentCardEvent {
  final StudentCardRequestModel request;

  const SearchStudentForAssignmentEvent({
    required this.request,
  });

  @override
  List<Object?> get props => [request];
}

final class AssignStudentCardEvent
    extends StudentCardEvent {

  final AssignmentCardRequestModel request;

  const AssignStudentCardEvent({
    required this.request,
  });

  @override
  List<Object?> get props => [request];
}