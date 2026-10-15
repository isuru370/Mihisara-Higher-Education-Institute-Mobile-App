part of 'teacher_students_bloc.dart';

sealed class TeacherStudentsState extends Equatable {
  const TeacherStudentsState();

  @override
  List<Object?> get props => [];
}

final class TeacherStudentsInitial extends TeacherStudentsState {}

final class TeacherStudentsLoading extends TeacherStudentsState {}

final class TeacherStudentsLoaded extends TeacherStudentsState {
  final TeacherStudentsModel data;

  const TeacherStudentsLoaded({
    required this.data,
  });

  @override
  List<Object?> get props => [data];
}

final class TeacherStudentsError extends TeacherStudentsState {
  final String message;

  const TeacherStudentsError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}