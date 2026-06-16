part of 'tute_bloc.dart';

sealed class TuteEvent extends Equatable {
  const TuteEvent();

  @override
  List<Object?> get props => [];
}

final class LoadAllTuteEvent extends TuteEvent {
  final FetchStudentTuteRequestModel fetchStudentTuteRequestModel;

  const LoadAllTuteEvent({required this.fetchStudentTuteRequestModel});

  @override
  List<Object?> get props => [fetchStudentTuteRequestModel];
}

final class CreateTuteEvent extends TuteEvent {
  final int studentId;
  final int studentClassEnrollmentId;
  final String issuedMonth;
  final bool isIssued;
  final String? issuedAt;
  final int? issuedBy;
  final String? note;

  const CreateTuteEvent({
    required this.studentId,
    required this.studentClassEnrollmentId,
    required this.issuedMonth,
    this.isIssued = false,
    this.issuedAt,
    this.issuedBy,
    this.note,
  });

  @override
  List<Object?> get props => [
    studentId,
    studentClassEnrollmentId,
    issuedMonth,
    isIssued,
    issuedAt,
    issuedBy,
    note,
  ];
}
