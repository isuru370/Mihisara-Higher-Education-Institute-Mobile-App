part of 'student_grade_bloc.dart';

sealed class StudentGradeState extends Equatable {
  const StudentGradeState();

  @override
  List<Object> get props => [];
}

final class StudentGradeInitial extends StudentGradeState {}

final class StudentGradeLoading extends StudentGradeState {}

final class StudentGradeLoaded extends StudentGradeState {
  final List<StudentGradeModel> grades;

  const StudentGradeLoaded(this.grades);

  @override
  List<Object> get props => [grades];
}

final class StudentGradeError extends StudentGradeState {
  final String message;

  const StudentGradeError(this.message);

  @override
  List<Object> get props => [message];
}
