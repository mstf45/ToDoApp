import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/feature/auth/login/cubit/login_state.dart';
import 'package:todoapp/product/constants/auth_providers.dart';
import 'package:todoapp/product/service/auth_service.dart';
import 'package:todoapp/product/service/user_profile_service.dart';

final class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authService, this._userProfileService) : super(const LoginState());

  final IAuthService _authService;
  final IUserProfileService _userProfileService;

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: '', isSuccess: false));
    final result = await _authService.signInWithEmail(email: email, password: password);
    if (isClosed) return;

    await result.fold<Future<void>>(
      onSuccess: (user) async {
        final seen = await _userProfileService.updateLastSeen(user.uid);
        if (isClosed) return;
        seen.fold(
          onSuccess: (_) => emit(state.copyWith(isLoading: false, isSuccess: true)),
          onError: (message) => emit(state.copyWith(isLoading: false, errorMessage: message)),
        );
      },
      onError: (message) async {
        emit(state.copyWith(isLoading: false, errorMessage: message));
      },
    );
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(isLoading: true, errorMessage: '', isSuccess: false));
    final result = await _authService.signInWithGoogle();
    if (isClosed) return;

    await result.fold<Future<void>>(
      onSuccess: (user) async {
        final saved = await _userProfileService.saveFromAuthUser(
          user,
          username: user.displayName,
          providerId: user.providerId.isEmpty ? AuthProviders.google : user.providerId,
        );
        if (isClosed) return;
        saved.fold(
          onSuccess: (_) => emit(state.copyWith(isLoading: false, isSuccess: true)),
          onError: (message) => emit(state.copyWith(isLoading: false, errorMessage: message)),
        );
      },
      onError: (message) async {
        emit(state.copyWith(isLoading: false, errorMessage: message));
      },
    );
  }
}
