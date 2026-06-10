import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/services/auth_service.dart';
import 'package:todoapp/services/user_profile_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final UserProfileService _userProfileService;
  User? _user;
  bool _isLoading = true;
  String? errorMessage;

  AuthProvider(this._authService, [UserProfileService? userProfileService])
      : _userProfileService = userProfileService ?? UserProfileService() {
    _authService.authStateChanges().listen((user) async {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    errorMessage = null;
    try {
      _isLoading = true;
      notifyListeners();
      final credential = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      _user = credential.user;
      if (_user != null) {
        await _userProfileService.updateLastSeen(_user!.uid);
      }
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (_) {
      errorMessage = 'Giriş sırasında bir hata oluştu.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    String? username,
  }) async {
    errorMessage = null;
    try {
      _isLoading = true;
      notifyListeners();
      final credential = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );
      
      final user = credential.user!;
      
      if (username != null && username.trim().isNotEmpty) {
        try {
          await user.updateDisplayName(username.trim());
        } catch (_) {
          // ignore profile update errors
        }
      }

      await _userProfileService.saveFromAuthUser(
        user,
        username: username,
        providerId: user.providerData.isNotEmpty
            ? user.providerData.first.providerId
            : 'password',
      );

      _user = user;
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      // ignore: avoid_print
      print('Signup error: $e');
      errorMessage = 'Kayıt sırasında bir hata oluştu.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithGoogle() async {
    errorMessage = null;
    try {
      _isLoading = true;
      notifyListeners();
      final credential = await _authService.signInWithGoogle();
      final user = credential.user!;

      await _userProfileService.saveFromAuthUser(
        user,
        username: user.displayName,
        providerId: user.providerData.isNotEmpty
            ? user.providerData.first.providerId
            : 'google.com',
      );

      _user = user;
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (_) {
      errorMessage = 'Google ile giriş yapılamadı.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    await _authService.signOut();
    _user = null;
    _isLoading = false;
    notifyListeners();
  }
}
