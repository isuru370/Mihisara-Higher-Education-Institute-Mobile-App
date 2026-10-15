import 're_assign_data_model.dart';

class ReAssignResponseModel {
  final bool status;
  final String message;
  final ReAssignDataModel? data;

  const ReAssignResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory ReAssignResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ReAssignResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] == null
          ? null
          : ReAssignDataModel.fromJson(json['data']),
    );
  }
}