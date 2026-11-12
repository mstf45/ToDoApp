import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/feature/auth/model/auth_user.dart';
import 'package:todoapp/feature/auth/model/user_profile.dart';
import 'package:todoapp/product/constants/app_strings.dart';
import 'package:todoapp/product/constants/auth_providers.dart';
import 'package:todoapp/product/constants/firestore_paths.dart';
import 'package:todoapp/product/logger/app_logger.dart';
import 'package:todoapp/product/network/product_result.dart';
import 'package:todoapp/product/service/user_profile_service.dart';

final class UserProfileServiceImpl implements IUserProfileService {
  UserProfileServiceImpl({FirebaseFirestore? firestore}) : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _db => _firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _profiles => _db.collection(FirestorePaths.userProfiles);

  @override
  Future<ProductResult<UserProfile>> saveFromAuthUser(
    AuthUser user, {
    String? username,
    String providerId = AuthProviders.password,
  }) async {
    try {
      final profile = UserProfile(
        uid: user.uid,
        email: user.email,
        username: _resolveUsername(user, username),
        photoUrl: user.photoUrl,
        phoneNumber: user.phoneNumber,
        emailVerified: user.emailVerified,
        providerId: providerId,
        createdAt: DateTime.now(),
      );
      await _profiles.doc(profile.uid).set(_toFirestore(profile), SetOptions(merge: true));
      return ProductSuccess<UserProfile>(profile);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(AppStrings.profileSaveFailed, e, stackTrace);
      return const ProductFailure<UserProfile>(AppStrings.profileSaveFailed);
    }
  }

  @override
  Future<ProductResult<bool>> updateLastSeen(String uid) async {
    try {
      await _profiles.doc(uid).set(
        {'lastSeen': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      );
      return const ProductSuccess<bool>(true);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(AppStrings.profileSaveFailed, e, stackTrace);
      return const ProductFailure<bool>(AppStrings.profileSaveFailed);
    }
  }

  @override
  Future<ProductResult<UserProfile>> getProfile(String uid) async {
    try {
      final doc = await _profiles.doc(uid).get();
      final data = doc.data();
      if (!doc.exists || data == null) {
        return const ProductFailure<UserProfile>(AppStrings.profileNotFound);
      }
      return ProductSuccess<UserProfile>(_fromFirestore(data));
    } on Exception catch (e, stackTrace) {
      AppLogger.error(AppStrings.profileSaveFailed, e, stackTrace);
      return const ProductFailure<UserProfile>(AppStrings.profileSaveFailed);
    }
  }

  Map<String, dynamic> _toFirestore(UserProfile profile) {
    return {
      'uid': profile.uid,
      'email': profile.email,
      'username': profile.username,
      'photoUrl': profile.photoUrl,
      'phoneNumber': profile.phoneNumber,
      'emailVerified': profile.emailVerified,
      'providerId': profile.providerId,
      'createdAt': profile.createdAt != null ? Timestamp.fromDate(profile.createdAt!) : FieldValue.serverTimestamp(),
      'lastSeen': FieldValue.serverTimestamp(),
    };
  }

  UserProfile _fromFirestore(Map<String, dynamic> data) {
    return UserProfile(
      uid: data['uid'] as String? ?? '',
      email: data['email'] as String? ?? '',
      username: data['username'] as String? ?? data['displayName'] as String? ?? '',
      photoUrl: data['photoUrl'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String? ?? '',
      emailVerified: data['emailVerified'] as bool? ?? false,
      providerId: data['providerId'] as String? ?? AuthProviders.password,
      createdAt: _date(data['createdAt']),
      lastSeen: _date(data['lastSeen']),
    );
  }

  DateTime? _date(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  String _resolveUsername(AuthUser user, String? username) {
    final typed = username?.trim() ?? '';
    if (typed.isNotEmpty) return typed;
    if (user.displayName.trim().isNotEmpty) return user.displayName.trim();
    return _emailLocalPart(user.email);
  }

  String _emailLocalPart(String email) {
    if (!email.contains('@')) return '';
    return email.split('@').first;
  }
}
