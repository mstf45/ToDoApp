import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/core/theme/app_page_padding.dart';
import 'package:todoapp/core/theme/app_sizes.dart';
import 'package:todoapp/core/theme/app_text_styles.dart';
import 'package:todoapp/core/theme/context_extension.dart';
import 'package:todoapp/core/theme/product_text.dart';
import 'package:todoapp/feature/auth/login/cubit/login_cubit.dart';
import 'package:todoapp/feature/auth/login/cubit/login_state.dart';
import 'package:todoapp/feature/auth/register/cubit/register_cubit.dart';
import 'package:todoapp/feature/auth/register/register_page.dart';
import 'package:todoapp/product/constants/app_assets.dart';
import 'package:todoapp/product/environment/app_environment.dart';
import 'package:todoapp/product/constants/app_strings.dart';
import 'package:todoapp/product/container/product_container.dart';
import 'package:todoapp/product/service/auth_service.dart';
import 'package:todoapp/product/service/user_profile_service.dart';
import 'package:todoapp/product/widget/auth_text_field.dart';
import 'package:todoapp/product/widget/product_loading_button.dart';
import 'package:todoapp/product/widget/product_toast.dart';
import 'package:todoapp/product/widget/theme_mode_button.dart';

part 'view/login_page_mixin.dart';
part 'view/widget/login_page_body.dart';

final class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

final class LoginPageState extends State<LoginPage> with LoginPageMixin {
  @override
  Widget build(BuildContext context) {
    return const LoginPageBody();
  }
}
