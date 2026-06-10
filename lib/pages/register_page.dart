import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/constants/app_strings.dart';
import 'package:todoapp/providers/auth_provider.dart';
import 'package:todoapp/providers/todo_provider.dart';
import 'package:todoapp/theme/app_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLoading = auth.isLoading;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceDark,
        title: const Text(AppStrings.signUp),
      ),
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _usernameController,
                  hintText: AppStrings.username,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _emailController,
                  hintText: AppStrings.email,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _passwordController,
                  hintText: AppStrings.password,
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _passwordConfirmController,
                  hintText: AppStrings.confirmPassword,
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 20),
                if (auth.errorMessage != null) ...[
                  Text(
                    auth.errorMessage!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                  const SizedBox(height: 12),
                ],
                ElevatedButton(
                  onPressed: isLoading ? null : _register,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(AppStrings.signUp),
                ),
              ],
            ),
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

  Future<void> _register() async {
    final auth = context.read<AuthProvider>();
    final todoProvider = context.read<TodoProvider>();

    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.fillAllFields)),
      );
      return;
    }

    if (_passwordController.text != _passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.passwordsDoNotMatch)),
      );
      return;
    }

    final success = await auth.signUpWithEmail(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
    );

    if (success) {
      await todoProvider.loadTodos();
      Navigator.pop(context);
    }
  }
}
