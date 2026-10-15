part of 'teacher_students_bloc.dart';

sealed class TeacherStudentsEvent extends Equatable {
  const TeacherStudentsEvent();

  @override
  List<Object?> get props => [];
}

/// Load all students
final class FetchTeacherStudents extends TeacherStudentsEvent {
  final int? classId;

  const FetchTeacherStudents({
    this.classId,
  });

  @override
  List<Object?> get props => [classId];
}