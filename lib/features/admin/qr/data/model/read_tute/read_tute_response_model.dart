import 'read_tute_data_model.dart';

class ReadTuteResponseModel {
  final bool success;
  final String message;
  final ReadTuteDataModel? data;

  ReadTuteResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ReadTuteResponseModel.fromJson(Map<String, dynamic> json) {
    return ReadTuteResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? ReadTuteDataModel.fromJson(json['data'])
          : null,
    );
  }
}