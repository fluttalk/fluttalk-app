import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final String? hintText;
  final String? defaultText;
  final Widget? prefixIcon;
  final TextEditingController textEditingController;
  const CommonTextField({
    this.prefixIcon,
    this.hintText,
    this.defaultText,
    required this.textEditingController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: MyColors.neutralOffWhite,
        hintText: hintText,
        contentPadding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 10,
        ),
        hintStyle: const TextStyle(
          color: MyColors.neutralDisabled,
        ),
      ),
    );
  }
}
