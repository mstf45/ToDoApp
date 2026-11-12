part of '../../register_page.dart';

final class RegisterPageBody extends StatelessWidget {
  const RegisterPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final page = context.findAncestorStateOfType<RegisterPageState>()!;

    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterCubit, RegisterState>(
          listenWhen: (previous, current) =>
              current.isSuccess && !previous.isSuccess,
          listener: (context, state) => page.onRegistered(),
        ),
        BlocListener<SessionCubit, SessionState>(
          listenWhen: (previous, current) => current.status != previous.status,
          listener: (context, state) {
            if (!context.read<RegisterCubit>().state.isSuccess) return;
            page.openHomeIfReady();
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: ProductText.h3(context, AppStrings.signUp),
          actions: const [ThemeModeButton()],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const AppPagePadding.horizontal24(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.gap16),
                ProductText.body(context, AppStrings.registerSubtitle),
                if (AppEnvironment.isDev) ...[
                  const SizedBox(height: AppSizes.gap8),
                  ProductText.caption(context, AppStrings.devEnvironmentLabel),
                ],
                const SizedBox(height: AppSizes.gap24),
                AuthTextField(
                  controller: page.usernameController,
                  hintText: AppStrings.username,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: AppSizes.gap16),
                AuthTextField(
                  controller: page.emailController,
                  hintText: AppStrings.email,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: AppSizes.gap16),
                AuthTextField(
                  controller: page.passwordController,
                  hintText: AppStrings.password,
                  icon: Icons.lock_outline,
                  obscureListenable: page.passwordObscureNotifier,
                ),
                const SizedBox(height: AppSizes.gap16),
                AuthTextField(
                  controller: page.confirmPasswordController,
                  hintText: AppStrings.confirmPassword,
                  icon: Icons.lock_outline,
                  obscureListenable: page.confirmObscureNotifier,
                ),
                const SizedBox(height: AppSizes.gap16),
                BlocSelector<RegisterCubit, RegisterState, String>(
                  selector: (state) => state.errorMessage,
                  builder: (context, errorMessage) {
                    if (errorMessage.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: const AppPagePadding.bottom16(),
                      child: Text(
                        errorMessage,
                        style: TextStyle(
                            color: context.colorScheme.error,
                            fontSize: AppTextStyles.bodySize),
                      ),
                    );
                  },
                ),
                BlocSelector<RegisterCubit, RegisterState, bool>(
                  selector: (state) => state.isLoading,
                  builder: (context, isLoading) {
                    return ProductLoadingButton(
                      label: AppStrings.signUp,
                      isLoading: isLoading,
                      onPressed: page.onRegisterPressed,
                    );
                  },
                ),
                const SizedBox(height: AppSizes.gap32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
