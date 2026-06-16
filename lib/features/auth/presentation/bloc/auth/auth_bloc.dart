import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexorait_education_app/features/auth/data/models/user_model.dart';
import '../../../../../core/errors/app_exceptions.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  // ---------------- Login ----------------
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final response = await loginUseCase.execute(
        event.email,
        event.password,
      );

      emit(AuthSuccess(response.token,response.user));
    } on AppException catch (e) {
      emit(AuthFailure(e.message));
    } catch (e) {
      emit(const AuthFailure('Something went wrong'));
    }
  }

  // ---------------- Logout ----------------
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await logoutUseCase.execute();
      emit(AuthInitial()); // back to login page
    } catch (e) {
      emit(const AuthFailure('Failed to logout'));
    }
  }
}
