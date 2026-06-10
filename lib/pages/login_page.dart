import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/constants/app_strings.dart';
import 'package:todoapp/providers/auth_provider.dart';
import 'package:todoapp/providers/todo_provider.dart';
import 'package:todoapp/pages/register_page.dart';
import 'package:todoapp/theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // passphrase removed: we will derive key from the user's password

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // no passphrase controller to dispose
    super.dispose();
  }
  /// Mustafa Özcan
  /// mustafa452017@gmail.com
  /// Deneme*1
  /// test


  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLoading = auth.isLoading;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                AppStrings.appTitle,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.loginSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                hintText: AppStrings.email,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _passwordController,
                hintText: AppStrings.password,
                icon: Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 20),
              if (auth.errorMessage != null) ...[
                Text(
                  auth.errorMessage!,
                  style: const TextStyle(color: Colors.redAccent),
                ),
                const SizedBox(height: 12),
              ],
              ElevatedButton(
                onPressed: isLoading ? null : _signIn,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(AppStrings.login),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterPage(),
                          ),
                        );
                      },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(AppStrings.signUp),
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white12),
              const SizedBox(height: 18),
              Text(
                AppStrings.orContinue,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: isLoading ? null : _signInWithGoogle,
                icon: const Icon(Icons.login_outlined),
                label: const Text(AppStrings.continueWithGoogle),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      onTapUpOutside: (event) => FocusScope.of(context).unfocus(),
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Future<void> _signIn() async {
    final auth = context.read<AuthProvider>();
    final todoProvider = context.read<TodoProvider>();
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.fillAllFields)),
      );
      return;
    }

    final success = await auth.signInWithEmail(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (success) {
      await todoProvider.loadTodos();
    }
  }



  Future<void> _signInWithGoogle() async {
    final auth = context.read<AuthProvider>();
    final todoProvider = context.read<TodoProvider>();
    final success = await auth.signInWithGoogle();
    if (success) {
      await todoProvider.loadTodos();
    }
  }
}
