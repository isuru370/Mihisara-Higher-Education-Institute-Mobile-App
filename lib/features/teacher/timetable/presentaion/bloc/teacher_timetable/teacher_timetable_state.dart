part of 'teacher_timetable_bloc.dart';

sealed class TeacherTimetableState extends Equatable {
  const TeacherTimetableState();

  @override
  List<Object?> get props => [];
}

final class TeacherTimetableInitial extends TeacherTimetableState {}

final class TeacherTimetableLoading extends TeacherTimetableState {}

final class TeacherTimetableLoaded extends TeacherTimetableState {
  final TeacherTimetableModel timetable;

  const TeacherTimetableLoaded({required this.timetable});

  @override
  List<Object?> get props => [timetable];
}

final class TeacherTimetableError extends TeacherTimetableState {
  final String message;

  const TeacherTimetableError({required this.message});

  @override
  List<Object?> get props => [message];
}
