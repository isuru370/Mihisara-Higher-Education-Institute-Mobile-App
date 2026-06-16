part of 'read_student_bloc.dart';

sealed class ReadStudentEvent extends Equatable {
  const ReadStudentEvent();

  @override
  List<Object> get props => [];
}
class ReadStudentRequested extends ReadStudentEvent {
  final String qrCode;

  const ReadStudentRequested({
    required this.qrCode,
  });

  @override
  List<Object> get props => [qrCode];
}