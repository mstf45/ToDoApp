import 'package:material_ui/material_ui.dart';

final class AppSizes {
  const AppSizes._();

  static const double gap8 = 8;
  static const double gap16 = 16;
  static const double gap20 = 20;
  static const double gap24 = 24;
  static const double gap32 = 32;
  static const double iconSmall = 16;
  static const double iconMedium = 24;
  static const double iconLarge = 32;
  static const double indicator = 20;
  static const double indicatorStroke = 2;
  static const double checkbox = 28;
  static const double menuButton = 32;
  static const double dividerHeight = 48;
  static const double dividerWidth = 1;
  static const double emptyLottie = 200;
  static const double logo = 72;
  static const double borderWidth = 2;
  static const double borderThin = 1;
  static const double accentWidth = 6;
  static const double buttonHeight = 48;
  static const double checkIcon = 16;
}

final class AppRadius {
  const AppRadius._();

  static const double small = 8;
  static const double medium = 16;

  static const double large = 24;

  static const BorderRadius mediumAll = BorderRadius.all(Radius.circular(medium));
  static const BorderRadius largeAll = BorderRadius.all(Radius.circular(large));
  static const BorderRadius smallAll = BorderRadius.all(Radius.circular(small));
  static const BorderRadius leftMedium = BorderRadius.horizontal(left: Radius.circular(medium));
  static const BorderRadius rightMedium = BorderRadius.horizontal(right: Radius.circular(medium));
  static const BorderRadius topMedium = BorderRadius.vertical(top: Radius.circular(medium));
  static const BorderRadius topLarge = BorderRadius.vertical(top: Radius.circular(large));
}
