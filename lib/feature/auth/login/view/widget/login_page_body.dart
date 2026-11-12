part of '../../login_page.dart';

final class LoginPageBody extends StatelessWidget {
  const LoginPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final page = context.findAncestorStateOfType<LoginPageState>()!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const AppPagePadding.horizontal24(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(alignment: Alignment.centerRight, child: ThemeModeButton()),
              const SizedBox(height: AppSizes.gap16),
              ClipRRect(
                borderRadius: AppRadius.mediumAll,
                child: Image.asset(
                  AppAssets.logo,
                  width: AppSizes.logo,
                  height: AppSizes.logo,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: AppSizes.gap24),
              ProductText.h1(context, AppStrings.appTitle),
              const SizedBox(height: AppSizes.gap8),
              ProductText.body(context, AppStrings.loginSubtitle),
              if (AppEnvironment.isDev) ...[
                const SizedBox(height: AppSizes.gap8),
                ProductText.caption(context, AppStrings.devEnvironmentLabel),
              ],
              const SizedBox(height: AppSizes.gap32),
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
                obscureListenable: page.obscureNotifier,
              ),
              const SizedBox(height: AppSizes.gap16),
              BlocSelector<LoginCubit, LoginState, String>(
                selector: (state) => state.errorMessage,
                builder: (context, errorMessage) {
                  if (errorMessage.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const AppPagePadding.bottom16(),
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: context.colorScheme.error, fontSize: AppTextStyles.bodySize),
                    ),
                  );
                },
              ),
              BlocSelector<LoginCubit, LoginState, bool>(
                selector: (state) => state.isLoading,
                builder: (context, isLoading) {
                  return Column(
                    children: [
                      ProductLoadingButton(
                        label: AppStrings.login,
                        isLoading: isLoading,
                        onPressed: page.onLoginPressed,
                      ),
                      const SizedBox(height: AppSizes.gap16),
                      ProductLoadingButton(
                        label: AppStrings.signUp,
                        isLoading: false,
                        outlined: true,
                        onPressed: isLoading ? null : page.onRegisterPressed,
                      ),
                      const SizedBox(height: AppSizes.gap20),
                      const Divider(),
                      const SizedBox(height: AppSizes.gap16),
                      ProductText.body(context, AppStrings.orContinue),

                      const SizedBox(height: AppSizes.gap16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: isLoading ? null : page.onGooglePressed,
                          icon: const Icon(Icons.login_outlined),
                          label: const Text(AppStrings.continueWithGoogle),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSizes.gap32),
            ],
          ),
        ),
      ),
    );
  }
}
