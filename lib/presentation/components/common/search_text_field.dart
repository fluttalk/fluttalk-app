import 'package:fluttalk/gen/assets.gen.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final String placeholder;
  const SearchTextField({
    required this.placeholder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 8),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Assets.icons.searchLight
              .image(scale: 2, color: MyColors.neutralDisabled),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: MyColors.neutralOffWhite,
          hintText: placeholder,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          hintStyle: const TextStyle(
            color: MyColors.neutralDisabled,
          ),
        ),
      ),
    );
  }
}
