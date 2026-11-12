import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/feature/auth/login/cubit/login_cubit.dart';
import 'package:todoapp/feature/auth/login/login_page.dart';
import 'package:todoapp/feature/home/home/home_page.dart';
import 'package:todoapp/product/application/session_cubit.dart';
import 'package:todoapp/product/application/session_state.dart';
import 'package:todoapp/product/container/product_container.dart';
import 'package:todoapp/product/service/auth_service.dart';
import 'package:todoapp/product/service/user_profile_service.dart';
import 'package:todoapp/product/widget/session_splash.dart';

final class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, SessionStatus>(
      selector: (state) => state.status,
      builder: (context, status) {
        return switch (status) {
          SessionStatus.unknown => const SessionSplash(),
          SessionStatus.authenticated => const HomePage(),
          SessionStatus.unauthenticated => BlocProvider(
              create: (_) => LoginCubit(
                ProductContainer.read<IAuthService>(),
                ProductContainer.read<IUserProfileService>(),
              ),
              child: const LoginPage(),
            ),
        };
      },
    );
  }
}
