import 'addmission_model.dart';

class AdmissionResponseModel {
  final bool success;
  final List<AddmissionModel> data;

  AdmissionResponseModel({required this.success, required this.data});

  factory AdmissionResponseModel.fromJson(Map<String, dynamic> json) {
    return AdmissionResponseModel(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => AddmissionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
