part of 'students_bloc.dart';

sealed class StudentsEvent extends Equatable {
  const StudentsEvent();

  @override
  List<Object?> get props => [];
}

class FetchStudents extends StudentsEvent {
  final String token;

  const FetchStudents(this.token);

  @override
  List<Object> get props => [token];
}

class FetchStudentCustomIds extends StudentsEvent {
  final String token;
  final String? search;
  final String? month;

  const FetchStudentCustomIds({required this.token, this.search, this.month});

  @override
  List<Object?> get props => [token, search, month];
}

final class CreateStudentEvent extends StudentsEvent {
  final StudentModel student;

  const CreateStudentEvent({required this.student});

  @override
  List<Object> get props => [student];
}
