part of '../login_page.dart';

mixin LoginPageMixin on State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscureNotifier = ValueNotifier<bool>(true);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    obscureNotifier.dispose();
    super.dispose();
  }

  void onLoginPressed() {
    emailController.text = 'mustafa452017@gmail.com';
    passwordController.text = 'Deneme*1';
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ProductToast.show(context, AppStrings.fillAllFields, isError: true);
      return;
    }
    unawaited(context
        .read<LoginCubit>()
        .signInWithEmail(email: email, password: password));
  }

  void onGooglePressed() {
    unawaited(context.read<LoginCubit>().signInWithGoogle());
  }

  void onRegisterPressed() {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BlocProvider(
            create: (_) => RegisterCubit(
              ProductContainer.read<IAuthService>(),
              ProductContainer.read<IUserProfileService>(),
            ),
            child: const RegisterPage(),
          ),
        ),
      ),
    );
  }
}
