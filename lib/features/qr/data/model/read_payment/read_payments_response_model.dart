import 'read_payment_data_model.dart';

class ReadPaymentResponseModel {
  final String status;
  final String message;
  final ReadPaymentDataModel? data;

  ReadPaymentResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ReadPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return ReadPaymentResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null
          ? ReadPaymentDataModel.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
