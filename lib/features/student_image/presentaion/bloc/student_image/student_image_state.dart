part of 'student_image_bloc.dart';

sealed class StudentImageState
    extends Equatable {

  const StudentImageState();

  @override
  List<Object> get props => [];
}

final class StudentImageInitial
    extends StudentImageState {}

final class StudentImageLoading
    extends StudentImageState {}

final class StudentImageUpdating
    extends StudentImageState {}

final class StudentImageLoaded
    extends StudentImageState {

  final List<StudentImageModel> students;

  const StudentImageLoaded({
    required this.students,
  });

  @override
  List<Object> get props => [students];
}

final class StudentImageUpdateSuccess
    extends StudentImageState {

  final String message;

  const StudentImageUpdateSuccess({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

final class StudentImageError
    extends StudentImageState {

  final String message;

  const StudentImageError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}