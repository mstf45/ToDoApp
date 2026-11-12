import 'package:material_ui/material_ui.dart';
import 'package:todoapp/core/theme/app_sizes.dart';
import 'package:todoapp/core/theme/context_extension.dart';

final class ProductLoadingButton extends StatelessWidget {
  const ProductLoadingButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
    this.outlined = false,
    super.key,
  });

  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? SizedBox(
            width: AppSizes.indicator,
            height: AppSizes.indicator,
            child: CircularProgressIndicator(
              strokeWidth: AppSizes.indicatorStroke,
              color: outlined ? context.colorScheme.primary : context.colorScheme.onPrimary,
            ),
          )
        : Text(label);

    if (outlined) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
    );
  }
}
