import 'assignment_current_card_model.dart';
import 'assignment_student_model.dart';

class AssignmentSearchStudentDataModel {
  final AssignmentStudentModel student;
  final AssignmentCurrentCardModel? currentCard;
  final bool hasCard;
  final String message;

  const AssignmentSearchStudentDataModel({
    required this.student,
    required this.currentCard,
    required this.hasCard,
    required this.message,
  });

  factory AssignmentSearchStudentDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AssignmentSearchStudentDataModel(
      student: AssignmentStudentModel.fromJson(
        json['student'] ?? {},
      ),
      currentCard: json['current_card'] == null
          ? null
          : AssignmentCurrentCardModel.fromJson(
              json['current_card'],
            ),
      hasCard: json['has_card'] ?? false,
      message: json['message'] ?? '',
    );
  }
}