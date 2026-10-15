part of 'student_grade_bloc.dart';

sealed class StudentGradeEvent extends Equatable {
  const StudentGradeEvent();

  @override
  List<Object> get props => [];
}

class GetStudentGradesEvent extends StudentGradeEvent {
}
