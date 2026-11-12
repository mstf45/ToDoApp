import 'package:material_ui/material_ui.dart';

final class AppPagePadding extends EdgeInsets {
  const AppPagePadding.all8() : super.all(8);
  const AppPagePadding.all16() : super.all(16);
  const AppPagePadding.all20() : super.all(20);
  const AppPagePadding.all24() : super.all(24);
  const AppPagePadding.all32() : super.all(32);

  const AppPagePadding.horizontal16() : super.symmetric(horizontal: 16);
  const AppPagePadding.horizontal24() : super.symmetric(horizontal: 24, vertical: 16);
  const AppPagePadding.vertical16() : super.symmetric(vertical: 16);
  const AppPagePadding.menu() : super.symmetric(horizontal: 8);
  const AppPagePadding.stats() : super.fromLTRB(16, 8, 16, 16);
  const AppPagePadding.tile() : super.symmetric(horizontal: 16, vertical: 8);
  const AppPagePadding.sectionTitle() : super.fromLTRB(16, 16, 16, 8);
  const AppPagePadding.tileContent() : super.symmetric(horizontal: 16, vertical: 16);
  const AppPagePadding.sheet() : super.symmetric(vertical: 16);
  const AppPagePadding.bottom16() : super.only(bottom: 16);
  const AppPagePadding.top8() : super.only(top: 8);
  const AppPagePadding.top32() : super.only(top: 32);
}
