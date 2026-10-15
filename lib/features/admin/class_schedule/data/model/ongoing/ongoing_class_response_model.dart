import 'ongoing_class_model.dart';

class OngoingClassResponseModel {
  final bool success;
  final String message;
  final List<OngoingClassModel> data;

  const OngoingClassResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OngoingClassResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return OngoingClassResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(OngoingClassModel.fromJson)
          .toList(),
    );
  }
}