import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> execute() async {
    // call API (optional)
    await repository.logout();

    // delete token from local storage
    await repository.clearToken();
  }
}
