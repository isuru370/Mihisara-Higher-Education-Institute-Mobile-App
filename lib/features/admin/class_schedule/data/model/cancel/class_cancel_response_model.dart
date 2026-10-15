import '../class_schedule_model.dart';

class ClassCancelResponseModel {
  final bool success;
  final String message;
  final ClassScheduleModel data;

  const ClassCancelResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ClassCancelResponseModel.fromJson(Map<String, dynamic> json) {
    return ClassCancelResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ClassScheduleModel.fromJson(json['data'] ?? {}),
    );
  }
}
