part of 'teacher_classes_bloc.dart';

sealed class TeacherClassesEvent extends Equatable {
  const TeacherClassesEvent();

  @override
  List<Object> get props => [];
}

final class FetchTeacherClasses extends TeacherClassesEvent {
  const FetchTeacherClasses();
}