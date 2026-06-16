class AddmissionModel {
  final int id;
  final String name;
  final double amount;

  AddmissionModel({required this.id, required this.name, required this.amount});

  factory AddmissionModel.fromJson(Map<String, dynamic> json) {
    return AddmissionModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
    );
  }
}
