import 'package:flutter/material.dart';
import 'package:todoapp/components/color_components.dart';

class MyButton extends StatelessWidget {
  final String text;
  void Function()? onPressed;
  MyButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: ColorCustom.mybuttonbackgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              letterSpacing: 0.41,
              fontWeight: FontWeight.w500,
              color: ColorCustom.mybuttontextColor,
            ),
          ),
        ),
      ),
    );
  }
}