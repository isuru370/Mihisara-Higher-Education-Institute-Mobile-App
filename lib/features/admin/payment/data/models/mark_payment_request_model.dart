import 'mark_payment_item_model.dart';

class MarkPaymentRequestModel {
  final List<MarkPaymentItemModel> payments;

  const MarkPaymentRequestModel({
    required this.payments,
  });

  factory MarkPaymentRequestModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    final items = (json?['payments'] as List? ?? [])
        .whereType<Map>()
        .map(
          (e) => MarkPaymentItemModel.fromJson(
            Map<String, dynamic>.from(e),
          ),
        )
        .toList();

    return MarkPaymentRequestModel(
      payments: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payments': payments.map((e) => e.toJson()).toList(),
    };
  }
}

