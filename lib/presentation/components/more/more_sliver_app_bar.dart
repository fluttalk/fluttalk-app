import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:fluttalk/presentation/theme/my_text_styles.dart';
import 'package:flutter/material.dart';

class MoreSliverAppBar extends StatelessWidget {
  const MoreSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: MyColors.neutralWhite,
      title: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          'More',
          style: MyTextStyles.subheading1.copyWith(
            color: MyColors.neutralActive,
          ),
        ),
      ),
      scrolledUnderElevation: 0,
      centerTitle: false,
      pinned: true,
    );
  }
}
