import '../class_schedule_model.dart';

class ClassNewDayResponseModel {
  final bool success;
  final String message;
  final ClassScheduleModel data;

  const ClassNewDayResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ClassNewDayResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClassNewDayResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ClassScheduleModel.fromJson(
        json['data'] ?? {},
      ),
    );
  }
}