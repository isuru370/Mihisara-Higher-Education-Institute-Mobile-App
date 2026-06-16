class ToggleStatusResponseModel {
  final String status;
  final String message;

  ToggleStatusResponseModel({required this.status, required this.message});

  factory ToggleStatusResponseModel.fromJson(Map<String, dynamic> json) {
    return ToggleStatusResponseModel(
      status: json['status'],
      message: json['message'],
    );
  }
}
