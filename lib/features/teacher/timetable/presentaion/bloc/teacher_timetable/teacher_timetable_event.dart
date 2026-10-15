part of 'teacher_timetable_bloc.dart';

sealed class TeacherTimetableEvent extends Equatable {
  const TeacherTimetableEvent();

  @override
  List<Object?> get props => [];
}

final class FetchTeacherTimetable extends TeacherTimetableEvent {
  final String? date;

  const FetchTeacherTimetable({
    this.date,
  });

  @override
  List<Object?> get props => [date];
}