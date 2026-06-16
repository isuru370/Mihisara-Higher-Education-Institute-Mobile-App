import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/login_response_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<LoginResponseModel> login(String email, String password) {
    return remote.login(LoginRequestModel(email: email, password: password));
  }

  @override
  Future<void> logout() async {
    // Optional: call API logout
    try {
      await remote.logout(); // fix: was remoteDataSource.logout()
    } catch (_) {
      // ignore network errors
    }

    // Always clear token
    await clearToken();
  }

  @override
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}






