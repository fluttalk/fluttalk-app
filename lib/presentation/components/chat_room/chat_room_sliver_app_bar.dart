import 'package:fluttalk/gen/assets.gen.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:fluttalk/presentation/theme/my_text_styles.dart';
import 'package:flutter/material.dart';

class ChatRoomSliverAppBar extends StatelessWidget {
  const ChatRoomSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: MyColors.neutralWhite,
      title: Text(
        '채팅방',
        style: MyTextStyles.subheading1.copyWith(
          color: MyColors.neutralActive,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 8),
          child: InkWell(
            onTap: () {},
            child: Assets.icons.hamburger.image(
              scale: 2,
              color: MyColors.neutralActive,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1.0,
          color: MyColors.neutralLine,
        ),
      ),
      scrolledUnderElevation: 0,
      centerTitle: true,
      pinned: true,
    );
  }
}
