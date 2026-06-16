part of 'read_student_bloc.dart';

sealed class ReadStudentState extends Equatable {
  const ReadStudentState();

  @override
  List<Object?> get props => [];
}

final class ReadStudentInitial extends ReadStudentState {}

final class ReadStudentLoading extends ReadStudentState {}

final class ReadStudentLoaded extends ReadStudentState {
  final ReadStudentResponseModel response;

  const ReadStudentLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

final class ReadStudentError extends ReadStudentState {
  final String message;

  const ReadStudentError(this.message);

  @override
  List<Object?> get props => [message];
}
