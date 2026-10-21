import '../../../../core/storage/session_storage.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
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
    // The token is saved under SessionStorage's key, not 'token'.
    await SessionStorage.clear();
  }
}






