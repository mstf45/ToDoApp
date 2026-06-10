import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoapp/models/user_profile_model.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _profilesRef =>
      _firestore.collection('user_profiles');

  Future<void> saveProfile(UserProfile profile) async {
    await _profilesRef.doc(profile.uid).set(
          profile.toFirestore(),
          SetOptions(merge: true),
        );
  }

  Future<void> saveFromAuthUser(
    User user, {
    String? username,
    String providerId = 'password',
  }) async {
    final profile = UserProfile(
      uid: user.uid,
      email: user.email ?? '',
      username: username?.trim().isNotEmpty == true
          ? username!.trim()
          : (user.displayName?.trim().isNotEmpty == true
              ? user.displayName!.trim()
              : _emailLocalPart(user.email)),
      photoUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
      emailVerified: user.emailVerified,
      providerId: providerId,
      createdAt: DateTime.now(),
    );
    await saveProfile(profile);
  }

  Future<void> updateLastSeen(String uid) async {
    await _profilesRef.doc(uid).set(
      {'lastSeen': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  Future<UserProfile?> getProfile(String uid) async {
    final doc = await _profilesRef.doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserProfile.fromFirestore(doc.data()!);
  }

  String _emailLocalPart(String? email) {
    if (email == null || !email.contains('@')) return '';
    return email.split('@').first;
  }
}
