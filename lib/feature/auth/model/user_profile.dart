import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:todoapp/product/constants/auth_providers.dart';

@immutable
final class UserProfile extends Equatable {
  const UserProfile({
    required this.uid,
    required this.email,
    required this.username,
    this.photoUrl = '',
    this.phoneNumber = '',
    this.emailVerified = false,
    this.providerId = AuthProviders.password,
    this.createdAt,
    this.lastSeen,
  });

  final String uid;
  final String email;
  final String username;
  final String photoUrl;
  final String phoneNumber;
  final bool emailVerified;
  final String providerId;
  final DateTime? createdAt;
  final DateTime? lastSeen;

  @override
  List<Object?> get props => [
        uid,
        email,
        username,
        photoUrl,
        phoneNumber,
        emailVerified,
        providerId,
        createdAt,
        lastSeen,
      ];
}
