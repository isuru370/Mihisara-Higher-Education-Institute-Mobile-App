import 'current_card_model.dart';
import 'student_card_data_model.dart';
import 'student_card_model.dart';
import 'student_mini_model.dart';

class StudentCardResponseModel extends StudentCardDataModel {
  const StudentCardResponseModel({
    required super.status,
    required super.message,
    super.student,
    super.currentCard,
    super.cards,
  });

  factory StudentCardResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudentCardResponseModel(
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