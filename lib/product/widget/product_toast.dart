import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todoapp/core/theme/app_durations.dart';
import 'package:todoapp/core/theme/app_page_padding.dart';
import 'package:todoapp/core/theme/app_sizes.dart';
import 'package:todoapp/core/theme/app_text_styles.dart';
import 'package:todoapp/core/theme/context_extension.dart';

final class ProductToast {
  const ProductToast._();

  static void show(BuildContext context, String message, {bool isError = false}) {
    final text = message.trim();
    if (text.isEmpty) return;

    final background = isError ? context.colorScheme.error : context.appThemeExtension.success;
    final textColor = context.colorScheme.onPrimary;

    if (_supportsFlutterToast) {
      unawaited(
        Fluttertoast.showToast(
          msg: text,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: background,
          textColor: textColor,
          fontSize: AppTextStyles.bodySize,
        ),
      );
      return;
    }

    _showOverlay(context, text, background, textColor);
  }

  static bool get _supportsFlutterToast {
    if (kIsWeb) return true;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android || TargetPlatform.iOS => true,
      _ => false,
    };
  }

  static void _showOverlay(BuildContext context, String message, Color background, Color textColor) {
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    final entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: AppSizes.gap24,
          right: AppSizes.gap24,
          bottom: AppSizes.gap32,
          child: IgnorePointer(
            child: Material(
              color: background,
              borderRadius: AppRadius.mediumAll,
              child: Padding(
                padding: const AppPagePadding.all16(),
                child: Text(
                  message,
                  style: TextStyle(color: textColor, fontSize: AppTextStyles.bodySize),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);
    unawaited(
      Future<void>.delayed(AppDurations.toast, () {
        entry.remove();
      }),
    );
  }
}
