part of 'student_image_bloc.dart';

sealed class StudentImageEvent
    extends Equatable {

  const StudentImageEvent();

  @override
  List<Object> get props => [];
}

// FETCH
final class FetchStudentImageEvent
    extends StudentImageEvent {

  const FetchStudentImageEvent();
}

// UPDATE
final class UpdateStudentImageEvent
    extends StudentImageEvent {

  final int studentId;
  final String quickImageId;

  const UpdateStudentImageEvent({
    required this.studentId,
    required this.quickImageId,
  });

  @override
  List<Object> get props => [
        studentId,
        quickImageId,
      ];
}