part of '../register_page.dart';

mixin RegisterPageMixin on State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final passwordObscureNotifier = ValueNotifier<bool>(true);
  final confirmObscureNotifier = ValueNotifier<bool>(true);
  bool _openedHome = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordObscureNotifier.dispose();
    confirmObscureNotifier.dispose();
    super.dispose();
  }

  void onRegisterPressed() {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ProductToast.show(context, AppStrings.fillAllFields, isError: true);
      return;
    }

    if (password != confirmPassword) {
      ProductToast.show(context, AppStrings.passwordsDoNotMatch, isError: true);
      return;
    }

    unawaited(
      context.read<RegisterCubit>().signUp(
            username: username,
            email: email,
            password: password,
          ),
    );
  }

  void onRegistered() {
    ProductToast.show(context, AppStrings.registerSuccess);
    openHomeIfReady();
  }

  void openHomeIfReady() {
    if (_openedHome || !mounted) return;
    if (context.read<SessionCubit>().state.status !=
        SessionStatus.authenticated) return;
    _openedHome = true;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
