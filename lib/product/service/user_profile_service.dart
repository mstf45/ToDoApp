import 'package:todoapp/feature/auth/model/auth_user.dart';
import 'package:todoapp/feature/auth/model/user_profile.dart';
import 'package:todoapp/product/constants/auth_providers.dart';
import 'package:todoapp/product/network/product_result.dart';

abstract interface class IUserProfileService {
  Future<ProductResult<UserProfile>> saveFromAuthUser(
    AuthUser user, {
    String? username,
    String providerId = AuthProviders.password,
  });

  Future<ProductResult<bool>> updateLastSeen(String uid);

  Future<ProductResult<UserProfile>> getProfile(String uid);
}
