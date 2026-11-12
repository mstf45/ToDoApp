import 'package:material_ui/material_ui.dart';
import 'package:todoapp/core/theme/context_extension.dart';

final class ProductText extends Text {
  ProductText.h1(BuildContext context, super.data, {super.key, super.textAlign})
      : super(style: context.appTextTheme.displayLarge);

  ProductText.h2(BuildContext context, super.data, {super.key, super.textAlign})
      : super(style: context.appTextTheme.displayMedium);

  ProductText.h3(BuildContext context, super.data, {super.key, super.textAlign})
      : super(style: context.appTextTheme.titleLarge);

  ProductText.body(BuildContext context, super.data, {super.key, super.textAlign})
      : super(style: context.appTextTheme.bodyMedium);

  ProductText.caption(
    BuildContext context,
    super.data, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
  }) : super(style: context.appTextTheme.bodySmall);
}
