import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todoapp/feature/auth/model/auth_user.dart';
import 'package:todoapp/product/constants/app_strings.dart';
import 'package:todoapp/product/constants/auth_providers.dart';
import 'package:todoapp/product/logger/app_logger.dart';
import 'package:todoapp/product/network/product_result.dart';
import 'package:todoapp/product/service/auth_service.dart';

final class AuthServiceImpl implements IAuthService {
  AuthServiceImpl({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth? _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuth get _auth => _firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<AuthUser?> authStateChanges() {
    return _auth.authStateChanges().map(_mapNullable);
  }

  @override
  AuthUser? get currentUser => _mapNullable(_auth.currentUser);

  @override
  Future<AuthUser?> reloadCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    await user.reload();
    return _mapNullable(_auth.currentUser);
  }

  @override
  Future<ProductResult<AuthUser>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _resultOf(credential.user, fallback: AppStrings.loginFailed);
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error(AppStrings.loginFailed, e, stackTrace);
      return ProductFailure<AuthUser>(e.message ?? AppStrings.loginFailed);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(AppStrings.loginFailed, e, stackTrace);
      return const ProductFailure<AuthUser>(AppStrings.loginFailed);
    }
  }

  @override
  Future<ProductResult<AuthUser>> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _resultOf(credential.user, fallback: AppStrings.registerFailed);
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error(AppStrings.registerFailed, e, stackTrace);
      return ProductFailure<AuthUser>(e.message ?? AppStrings.registerFailed);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(AppStrings.registerFailed, e, stackTrace);
      return const ProductFailure<AuthUser>(AppStrings.registerFailed);
    }
  }

  @override
  Future<ProductResult<AuthUser>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return const ProductFailure<AuthUser>(AppStrings.googleCancelled);
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return _resultOf(
        userCredential.user,
        fallback: AppStrings.googleFailed,
        providerId: AuthProviders.google,
      );
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error(AppStrings.googleFailed, e, stackTrace);
      return ProductFailure<AuthUser>(e.message ?? AppStrings.googleFailed);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(AppStrings.googleFailed, e, stackTrace);
      return const ProductFailure<AuthUser>(AppStrings.googleFailed);
    }
  }

  @override
  Future<ProductResult<AuthUser>> updateDisplayName(String username) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return const ProductFailure<AuthUser>(AppStrings.registerFailed);
      }
      final trimmed = username.trim();
      if (trimmed.isNotEmpty) {
        await user.updateDisplayName(trimmed);
        await user.reload();
      }
      return _resultOf(_auth.currentUser ?? user, fallback: AppStrings.registerFailed);
    } on FirebaseAuthException catch (e, stackTrace) {
      AppLogger.error(AppStrings.registerFailed, e, stackTrace);
      return ProductFailure<AuthUser>(e.message ?? AppStrings.registerFailed);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(AppStrings.registerFailed, e, stackTrace);
      return const ProductFailure<AuthUser>(AppStrings.registerFailed);
    }
  }

  @override
  Future<ProductResult<bool>> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      return const ProductSuccess<bool>(true);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(AppStrings.signOutFailed, e, stackTrace);
      return const ProductFailure<bool>(AppStrings.signOutFailed);
    }
  }

  ProductResult<AuthUser> _resultOf(User? user, {required String fallback, String? providerId}) {
    final mapped = _mapNullable(user, providerId: providerId);
    if (mapped == null) return ProductFailure<AuthUser>(fallback);
    return ProductSuccess<AuthUser>(mapped);
  }

  AuthUser? _mapNullable(User? user, {String? providerId}) {
    if (user == null) return null;
    final resolvedProvider = providerId ??
        (user.providerData.isNotEmpty ? user.providerData.first.providerId : AuthProviders.password);
    return AuthUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      photoUrl: user.photoURL ?? '',
      phoneNumber: user.phoneNumber ?? '',
      emailVerified: user.emailVerified,
      providerId: resolvedProvider,
    );
  }
}
