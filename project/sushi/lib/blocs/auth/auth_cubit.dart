import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial()) {
    checkAuth();
  }

  void checkAuth() {
    final user = _authService.currentUser;
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final credential = await _authService.signInWithEmail(email, password);
      if (credential != null && credential.user != null) {
        emit(Authenticated(credential.user!));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String email, String password, UserModel userModel) async {
    emit(AuthLoading());
    try {
      final credential = await _authService.registerWithEmail(email, password, userModel);
      if (credential != null && credential.user != null) {
        emit(Authenticated(credential.user!));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(AuthLoading());
    try {
      final credential = await _authService.signInWithGoogle();
      if (credential != null && credential.user != null) {
        emit(Authenticated(credential.user!));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    emit(Unauthenticated());
  }
}
