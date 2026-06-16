part of 'student_classes_bloc.dart';

sealed class StudentClassesState extends Equatable {
  const StudentClassesState();

  @override
  List<Object?> get props => [];
}

final class StudentClassesInitial extends StudentClassesState {}

final class StudentClassesLoading extends StudentClassesState {}

final class StudentClassesLoaded extends StudentClassesState {
  final StudentClassResponseModel response;

  const StudentClassesLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

final class StudentClassesError extends StudentClassesState {
  final String message;

  const StudentClassesError(this.message);

  @override
  List<Object?> get props => [message];
}
