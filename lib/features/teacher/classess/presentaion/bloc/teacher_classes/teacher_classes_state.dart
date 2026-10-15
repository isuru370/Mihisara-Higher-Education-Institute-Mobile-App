part of 'teacher_classes_bloc.dart';

sealed class TeacherClassesState extends Equatable {
  const TeacherClassesState();

  @override
  List<Object> get props => [];
}

final class TeacherClassesInitial extends TeacherClassesState {}

final class TeacherClassesLoading extends TeacherClassesState {}

final class TeacherClassesLoaded extends TeacherClassesState {
  final List<TeacherClassModel> classes;

  const TeacherClassesLoaded({
    required this.classes,
  });

  @override
  List<Object> get props => [classes];
}

final class TeacherClassesError extends TeacherClassesState {
  final String message;

  const TeacherClassesError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}