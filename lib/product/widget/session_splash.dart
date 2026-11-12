import 'package:material_ui/material_ui.dart';
import 'package:todoapp/core/theme/app_sizes.dart';
import 'package:todoapp/core/theme/product_text.dart';
import 'package:todoapp/product/constants/app_strings.dart';

final class SessionSplash extends StatelessWidget {
  const SessionSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProductText.h2(context, AppStrings.appTitle),
            const SizedBox(height: AppSizes.gap16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
