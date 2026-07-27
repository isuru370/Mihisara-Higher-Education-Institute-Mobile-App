part of 'student_card_bloc.dart';

sealed class StudentCardState extends Equatable {
  const StudentCardState();

  @override
  List<Object?> get props => [];
}

final class StudentCardInitial extends StudentCardState {}

final class StudentCardLoading extends StudentCardState {}

final class StudentCardLoaded extends StudentCardState {
  final StudentCardResponseModel response;

  const StudentCardLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

final class ReAssignStudentCardLoaded extends StudentCardState {
  final ReAssignResponseModel response;

  const ReAssignStudentCardLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

final class StudentCardError extends StudentCardState {
  final String message;

  const StudentCardError(this.message);

  @override
  List<Object?> get props => [message];
}