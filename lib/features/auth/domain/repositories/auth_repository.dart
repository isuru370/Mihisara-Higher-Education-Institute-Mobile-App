
import '../../data/models/login_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login(String email, String password);
  Future<void> logout();
  Future<void> clearToken(); // remove token from SharedPreferences
}
