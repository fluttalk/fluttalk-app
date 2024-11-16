import 'package:fluttalk/gen/assets.gen.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:fluttalk/presentation/theme/my_text_styles.dart';
import 'package:flutter/material.dart';

class ChatListSliverAppBar extends StatelessWidget {
  const ChatListSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: MyColors.neutralWhite,
      title: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          'Chats',
          style: MyTextStyles.subheading1.copyWith(
            color: MyColors.neutralActive,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 8),
          child: InkWell(
            onTap: () {},
            child: Assets.icons.messagePlusAlt.image(
              scale: 2,
              color: MyColors.neutralActive,
            ),
          ),
        ),
      ],
      scrolledUnderElevation: 0,
      centerTitle: false,
      pinned: true,
    );
  }
}
