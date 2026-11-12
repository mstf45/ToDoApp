import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:todoapp/product/constants/auth_providers.dart';

@immutable
final class AuthUser extends Equatable {
  const AuthUser({
    required this.uid,
    required this.email,
    this.displayName = '',
    this.photoUrl = '',
    this.phoneNumber = '',
    this.emailVerified = false,
    this.providerId = AuthProviders.password,
  });

  final String uid;
  final String email;
  final String displayName;
  final String photoUrl;
  final String phoneNumber;
  final bool emailVerified;
  final String providerId;

  @override
  List<Object?> get props => [uid, email, displayName, photoUrl, phoneNumber, emailVerified, providerId];
}
