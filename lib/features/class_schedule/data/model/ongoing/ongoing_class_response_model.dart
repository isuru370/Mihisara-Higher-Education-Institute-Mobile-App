import 'ongoing_class_model.dart';

class OngoingClassResponseModel {
  final bool success;
  final String message;
  final List<OngoingClassModel> data;

  OngoingClassResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OngoingClassResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OngoingClassResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map(
            (e) => OngoingClassModel.fromJson(e),
          )
          .toList(),
    );
  }
}