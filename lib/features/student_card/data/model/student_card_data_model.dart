import 'student_card_model.dart';
import 'current_card_model.dart';
import 'student_mini_model.dart';

class StudentCardDataModel {
  final bool status;
  final String message;

  final StudentMiniModel? student;

  final CurrentCardModel? currentCard;

  final List<StudentCardModel> cards;

  const StudentCardDataModel({
    required this.status,
    required this.message,
    this.student,
    this.currentCard,
    this.cards = const [],
  });

  factory StudentCardDataModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudentCardDataModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      student: json['student'] == null
          ? null
          : StudentMiniModel.fromJson(json['student']),
      currentCard: json['current_card'] == null
          ? null
          : CurrentCardModel.fromJson(json['current_card']),
      cards: json['cards'] == null
          ? []
          : (json['cards'] as List)
              .map((e) => StudentCardModel.fromJson(e))
              .toList(),
    );
  }
}