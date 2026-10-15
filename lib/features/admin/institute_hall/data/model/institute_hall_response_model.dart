import 'institute_hall_model.dart';

class InstituteHallResponseModel {
  final bool success;
  final List<InstituteHallModel> data;

  InstituteHallResponseModel({
    required this.success,
    required this.data,
  });

  factory InstituteHallResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return InstituteHallResponseModel(
      success: json['success'] ?? false,
      data: (json['data'] as List)
          .map((e) => InstituteHallModel.fromJson(e))
          .toList(),
    );
  }
}