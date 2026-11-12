import 'package:material_ui/material_ui.dart';

final class AuthTextField extends StatelessWidget {
  const AuthTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureListenable,
    this.keyboardType = TextInputType.text,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final ValueNotifier<bool>? obscureListenable;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    final listenable = obscureListenable;
    if (listenable == null) {
      return _field(obscure: false);
    }

    return ValueListenableBuilder<bool>(
      valueListenable: listenable,
      builder: (context, obscure, _) => _field(obscure: obscure),
    );
  }

  Widget _field({required bool obscure}) {
    final listenable = obscureListenable;
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        suffixIcon: listenable == null
            ? null
            : IconButton(
                onPressed: () => listenable.value = !listenable.value,
                icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              ),
      ),
    );
  }
}
