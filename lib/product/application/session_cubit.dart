import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/feature/auth/model/auth_user.dart';
import 'package:todoapp/product/application/session_state.dart';
import 'package:todoapp/product/logger/app_logger.dart';
import 'package:todoapp/product/service/auth_service.dart';

final class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._authService) : super(const SessionState()) {
    final current = _authService.currentUser;
    if (current == null || current.uid.isEmpty) {
      emit(const SessionState(status: SessionStatus.unauthenticated));
    }
    _subscription = _authService.authStateChanges().listen(
      _onUser,
      onError: _onError,
    );
  }

  final IAuthService _authService;
  late final StreamSubscription<AuthUser?> _subscription;

  Future<void> signOut() async {
    await _authService.signOut();
  }

  void _onUser(AuthUser? user) {
    unawaited(_applyUser(user));
  }

  Future<void> _applyUser(AuthUser? user) async {
    if (isClosed) return;
    if (user == null || user.uid.isEmpty) {
      emit(const SessionState(status: SessionStatus.unauthenticated));
      return;
    }

    var resolved = user;
    if (resolved.email.isEmpty) {
      try {
        final refreshed = await _authService.reloadCurrentUser();
        if (refreshed != null) resolved = refreshed;
      } on Exception catch (error, stackTrace) {
        AppLogger.error('$runtimeType', error, stackTrace);
        await _authService.signOut();
        if (isClosed) return;
        emit(const SessionState(status: SessionStatus.unauthenticated));
        return;
      }
    }

    if (isClosed) return;
    if (resolved.uid.isEmpty) {
      emit(const SessionState(status: SessionStatus.unauthenticated));
      return;
    }
    emit(SessionState(status: SessionStatus.authenticated, user: resolved));
  }

  void _onError(Object error, StackTrace stackTrace) {
    AppLogger.error('$runtimeType', error, stackTrace);
    if (isClosed) return;
    emit(const SessionState(status: SessionStatus.unauthenticated));
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
