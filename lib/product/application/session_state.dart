import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:todoapp/feature/auth/model/auth_user.dart';

enum SessionStatus { unknown, authenticated, unauthenticated }

@immutable
final class SessionState extends Equatable {
  const SessionState({
    this.status = SessionStatus.unknown,
    this.user,
  });

  final SessionStatus status;
  final AuthUser? user;

  SessionState copyWith({
    SessionStatus? status,
    AuthUser? user,
    bool clearUser = false,
  }) {
    return SessionState(
      status: status ?? this.status,
      user: clearUser ? null : user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, user];
}
