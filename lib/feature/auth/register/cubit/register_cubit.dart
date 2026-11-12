import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/feature/auth/model/auth_user.dart';
import 'package:todoapp/feature/auth/register/cubit/register_state.dart';
import 'package:todoapp/product/constants/auth_providers.dart';
import 'package:todoapp/product/service/auth_service.dart';
import 'package:todoapp/product/service/user_profile_service.dart';

final class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._authService, this._userProfileService)
      : super(const RegisterState());

  final IAuthService _authService;
  final IUserProfileService _userProfileService;

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: '', isSuccess: false));
    final result =
        await _authService.signUpWithEmail(email: email, password: password);
    if (isClosed) return;

    await result.fold<Future<void>>(
      onSuccess: (user) async {
        final named = await _authService.updateDisplayName(username);
        if (isClosed) return;
        final current = named.fold<AuthUser>(
          onSuccess: (updated) => updated,
          onError: (_) => user,
        );
        final saved = await _userProfileService.saveFromAuthUser(
          current,
          username: username,
          providerId: AuthProviders.password,
        );
        if (isClosed) return;
        saved.fold(
          onSuccess: (_) =>
              emit(state.copyWith(isLoading: false, isSuccess: true)),
          onError: (message) =>
              emit(state.copyWith(isLoading: false, errorMessage: message)),
        );
      },
      onError: (message) async {
        emit(state.copyWith(isLoading: false, errorMessage: message));
      },
    );
  }
}
