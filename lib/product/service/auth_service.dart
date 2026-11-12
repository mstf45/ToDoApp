import 'package:todoapp/feature/auth/model/auth_user.dart';
import 'package:todoapp/product/network/product_result.dart';

abstract interface class IAuthService {
  Stream<AuthUser?> authStateChanges();

  AuthUser? get currentUser;

  Future<AuthUser?> reloadCurrentUser();

  Future<ProductResult<AuthUser>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<ProductResult<AuthUser>> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<ProductResult<AuthUser>> signInWithGoogle();

  Future<ProductResult<AuthUser>> updateDisplayName(String username);

  Future<ProductResult<bool>> signOut();
}
