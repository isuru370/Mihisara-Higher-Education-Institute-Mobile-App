class SmsBalanceModel {
  final bool success;
  final int httpStatus;
  final int providerStatusCode;
  final SmsBalanceData data;

  SmsBalanceModel({
    required this.success,
    required this.httpStatus,
    required this.providerStatusCode,
    required this.data,
  });

  factory SmsBalanceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return SmsBalanceModel(
      success: json['success'] ?? false,
      httpStatus: json['http_status'] ?? 0,
      providerStatusCode:
          json['provider_status_code'] ?? 0,
      data: SmsBalanceData.fromJson(
        json['data'] ?? {},
      ),
    );
  }
}

class SmsBalanceData {
  final int statusCode;
  final String currentBalance;

  SmsBalanceData({
    required this.statusCode,
    required this.currentBalance,
  });

  factory SmsBalanceData.fromJson(
    Map<String, dynamic> json,
  ) {
    return SmsBalanceData(
      statusCode: json['status_code'] ?? 0,
      currentBalance:
          json['current_balance'] ?? '0',
    );
  }
}