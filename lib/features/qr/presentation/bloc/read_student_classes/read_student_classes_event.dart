part of 'read_student_classes_bloc.dart';

sealed class ReadStudentClassesEvent extends Equatable {
  const ReadStudentClassesEvent();

  @override
  List<Object> get props => [];
}

final class ReadStudentClassesRequested extends ReadStudentClassesEvent {
  final String qrCode;

  const ReadStudentClassesRequested({
    required this.qrCode,
  });

  @override
  List<Object> get props => [qrCode];
}
