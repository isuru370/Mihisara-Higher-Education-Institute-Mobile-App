part of 'student_classes_bloc.dart';

sealed class StudentClassesEvent extends Equatable {
  const StudentClassesEvent();

  @override
  List<Object?> get props => [];
}

// Event to fetch student classes
final class FetchStudentClasses extends StudentClassesEvent {
  final int studentId;

  const FetchStudentClasses({required this.studentId});

  @override
  List<Object?> get props => [studentId];
}
