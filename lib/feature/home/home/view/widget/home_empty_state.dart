import 'package:material_ui/material_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:todoapp/core/theme/app_page_padding.dart';
import 'package:todoapp/core/theme/app_sizes.dart';
import 'package:todoapp/core/theme/product_text.dart';
import 'package:todoapp/product/constants/app_assets.dart';
import 'package:todoapp/product/constants/app_strings.dart';

final class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const AppPagePadding.horizontal24(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: AppSizes.emptyLottie,
            height: AppSizes.emptyLottie,
            child: Lottie.asset(AppAssets.successLottie, repeat: false),
          ),
          const SizedBox(height: AppSizes.gap24),
          ProductText.h3(context, AppStrings.noTasks),
          const SizedBox(height: AppSizes.gap8),
          ProductText.body(context, AppStrings.addFirstTask, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
