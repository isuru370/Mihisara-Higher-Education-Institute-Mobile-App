import '../class_schedule_model.dart';

class UpdateClassScheduleResponseModel {
  final bool success;
  final String message;
  final ClassScheduleModel data;

  const UpdateClassScheduleResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UpdateClassScheduleResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateClassScheduleResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ClassScheduleModel.fromJson(json['data'] ?? {}),
    );
  }
}
