import 'user_model.dart';

class LoginResponseModel {
  final String status;
  final String message;
  final String token;
  final UserModel user;

  LoginResponseModel({
    required this.status,
    required this.message,
    required this.token,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: (json['status'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      token: (json['token'] ?? '').toString(),
      user: UserModel.fromJson(
        (json['user'] as Map<String, dynamic>?) ?? <String, dynamic>{},
      ),
    );
  }
}
