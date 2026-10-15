class TeacherAddressModel {
  final String? address1;
  final String? address2;
  final String? address3;

  const TeacherAddressModel({
    this.address1,
    this.address2,
    this.address3,
  });

  factory TeacherAddressModel.fromJson(Map<String, dynamic> json) {
    return TeacherAddressModel(
      address1: json['address1'],
      address2: json['address2'],
      address3: json['address3'],
    );
  }
}