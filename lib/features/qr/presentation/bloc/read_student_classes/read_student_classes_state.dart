part of 'read_student_classes_bloc.dart';

sealed class ReadStudentClassesState extends Equatable {
  const ReadStudentClassesState();

  @override
  List<Object?> get props => [];
}

final class ReadStudentClassesInitial extends ReadStudentClassesState {}

final class ReadStudentClassesLoading extends ReadStudentClassesState {}

final class ReadStudentClassesSuccess extends ReadStudentClassesState {
  final ReadStudentClassesResponseModel response;

  const ReadStudentClassesSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class ReadStudentClassesError extends ReadStudentClassesState {
  final String message;

  const ReadStudentClassesError({required this.message});

  @override
  List<Object?> get props => [message];
}