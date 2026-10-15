import '../class_schedule_model.dart';

class ClassScheduleResponseModel {
  final bool success;
  final String message;
  final List<ClassScheduleModel> data;

  const ClassScheduleResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ClassScheduleResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClassScheduleResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map(
            (e) => ClassScheduleModel.fromJson(e),
          )
          .toList(),
    );
  }
}