import 'dart:async';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/core/theme/app_page_padding.dart';
import 'package:todoapp/core/theme/app_sizes.dart';
import 'package:todoapp/core/theme/context_extension.dart';
import 'package:todoapp/core/theme/product_text.dart';
import 'package:todoapp/feature/home/home/cubit/home_cubit.dart';
import 'package:todoapp/feature/home/home/cubit/home_state.dart';
import 'package:todoapp/feature/home/home/view/widget/add_edit_todo_sheet.dart';
import 'package:todoapp/feature/home/home/view/widget/home_stats_bar.dart';
import 'package:todoapp/feature/home/home/view/widget/home_todo_list.dart';
import 'package:todoapp/product/application/session_cubit.dart';
import 'package:todoapp/product/application/session_state.dart';
import 'package:todoapp/product/constants/app_strings.dart';
import 'package:todoapp/product/widget/product_toast.dart';
import 'package:todoapp/product/widget/theme_mode_button.dart';

part 'view/home_page_mixin.dart';
part 'view/widget/home_page_body.dart';

final class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

final class HomePageState extends State<HomePage> with HomePageMixin {
  @override
  Widget build(BuildContext context) {
    return const HomePageBody();
  }
}
