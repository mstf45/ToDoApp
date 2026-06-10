import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String email;
  final String username;
  final String? photoUrl;
  final String? phoneNumber;
  final bool emailVerified;
  final String providerId;
  final DateTime? createdAt;
  final DateTime? lastSeen;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.username,
    this.photoUrl,
    this.phoneNumber,
    this.emailVerified = false,
    this.providerId = 'password',
    this.createdAt,
    this.lastSeen,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'photoUrl': photoUrl ?? '',
      'phoneNumber': phoneNumber ?? '',
      'emailVerified': emailVerified,
      'providerId': providerId,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'lastSeen': FieldValue.serverTimestamp(),
    };
  }

  factory UserProfile.fromFirestore(Map<String, dynamic> data) {
    return UserProfile(
      uid: data['uid'] as String? ?? '',
      email: data['email'] as String? ?? '',
      username: data['username'] as String? ?? data['displayName'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      phoneNumber: data['phoneNumber'] as String?,
      emailVerified: data['emailVerified'] as bool? ?? false,
      providerId: data['providerId'] as String? ?? '',
      createdAt: _parseTimestamp(data['createdAt']),
      lastSeen: _parseTimestamp(data['lastSeen']),
    );
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
