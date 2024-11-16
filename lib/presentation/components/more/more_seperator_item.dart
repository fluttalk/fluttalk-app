import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class MoreSeperatorItem extends StatelessWidget {
  const MoreSeperatorItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 1,
        color: MyColors.neutralLine,
      ),
    );
  }
}
