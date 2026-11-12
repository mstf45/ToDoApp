import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/core/theme/app_page_padding.dart';
import 'package:todoapp/core/theme/app_sizes.dart';
import 'package:todoapp/core/theme/app_text_styles.dart';
import 'package:todoapp/core/theme/context_extension.dart';
import 'package:todoapp/core/theme/product_text.dart';
import 'package:todoapp/feature/auth/register/cubit/register_cubit.dart';
import 'package:todoapp/feature/auth/register/cubit/register_state.dart';
import 'package:todoapp/product/application/session_cubit.dart';
import 'package:todoapp/product/application/session_state.dart';
import 'package:todoapp/product/constants/app_strings.dart';
import 'package:todoapp/product/environment/app_environment.dart';
import 'package:todoapp/product/widget/auth_text_field.dart';
import 'package:todoapp/product/widget/product_loading_button.dart';
import 'package:todoapp/product/widget/product_toast.dart';
import 'package:todoapp/product/widget/theme_mode_button.dart';

part 'view/register_page_mixin.dart';
part 'view/widget/register_page_body.dart';

final class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

final class RegisterPageState extends State<RegisterPage>
    with RegisterPageMixin {
  @override
  Widget build(BuildContext context) {
    return const RegisterPageBody();
  }
}
