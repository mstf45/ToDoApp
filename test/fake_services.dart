import 'dart:async';

import 'package:todoapp/feature/auth/model/auth_user.dart';
import 'package:todoapp/feature/auth/model/user_profile.dart';
import 'package:todoapp/feature/home/home/model/todo.dart';
import 'package:todoapp/product/constants/app_strings.dart';
import 'package:todoapp/product/network/product_result.dart';
import 'package:todoapp/product/service/auth_service.dart';
import 'package:todoapp/product/service/todo_service.dart';
import 'package:todoapp/product/service/user_profile_service.dart';

final class FakeAuthService implements IAuthService {
  final StreamController<AuthUser?> _users =
      StreamController<AuthUser?>.broadcast();
  AuthUser? _current;

  @override
  Stream<AuthUser?> authStateChanges() {
    return Stream<AuthUser?>.multi((listener) {
      listener.add(_current);
      final subscription =
          _users.stream.listen(listener.add, onError: listener.addError);
      listener.onCancel = subscription.cancel;
    });
  }

  @override
  AuthUser? get currentUser => _current;

  @override
  Future<AuthUser?> reloadCurrentUser() async => currentUser;

  @override
  Future<ProductResult<AuthUser>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return const ProductFailure<AuthUser>(AppStrings.loginFailed);
  }

  @override
  Future<ProductResult<AuthUser>> signInWithGoogle() async {
    return const ProductFailure<AuthUser>(AppStrings.googleFailed);
  }

  @override
  Future<ProductResult<AuthUser>> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    _current = AuthUser(uid: 'uid-1', email: email);
    _users.add(_current);
    return ProductSuccess<AuthUser>(_current!);
  }

  @override
  Future<ProductResult<bool>> signOut() async {
    _current = null;
    _users.add(null);
    return const ProductSuccess<bool>(true);
  }

  @override
  Future<ProductResult<AuthUser>> updateDisplayName(String username) async {
    final user = _current;
    if (user == null)
      return const ProductFailure<AuthUser>(AppStrings.registerFailed);
    _current =
        AuthUser(uid: user.uid, email: user.email, displayName: username);
    return ProductSuccess<AuthUser>(_current!);
  }
}

final class FakeUserProfileService implements IUserProfileService {
  @override
  Future<ProductResult<UserProfile>> getProfile(String uid) async {
    return const ProductFailure<UserProfile>(AppStrings.profileNotFound);
  }

  @override
  Future<ProductResult<UserProfile>> saveFromAuthUser(
    AuthUser user, {
    String? username,
    String providerId = 'password',
  }) async {
    return ProductSuccess<UserProfile>(
      UserProfile(
        uid: user.uid,
        email: user.email,
        username: username ?? user.displayName,
      ),
    );
  }

  @override
  Future<ProductResult<bool>> updateLastSeen(String uid) async {
    return const ProductSuccess<bool>(true);
  }
}

final class FakeTodoService implements ITodoService {
  @override
  Future<List<Todo>> getTodos(String uid) async => const [];

  @override
  Future<List<String>> unsyncedIds(String uid) async => const [];

  @override
  Future<void> init() async {}

  @override
  Future<bool> saveTodos(String uid, List<Todo> todos) async => false;

  @override
  Stream<TodoSyncStatus> get syncEvents => const Stream<TodoSyncStatus>.empty();

  @override
  Future<TodoSyncStatus> syncPending(String uid) async => TodoSyncStatus.idle;
}
