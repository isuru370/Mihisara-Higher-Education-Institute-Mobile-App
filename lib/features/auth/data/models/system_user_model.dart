class SystemUserModel {
  final String customId;
  final String fname;
  final String lname;
  final String email;
  final String mobile;

  SystemUserModel({
    required this.customId,
    required this.fname,
    required this.lname,
    required this.email,
    required this.mobile,
  });

  factory SystemUserModel.fromJson(Map<String, dynamic> json) {
    return SystemUserModel(
      customId: json['custom_id'],
      fname: json['fname'],
      lname: json['lname'],
      email: json['email'],
      mobile: json['mobile'],
    );
  }
}
