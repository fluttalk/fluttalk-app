import 'package:fluttalk/domain/entities/friend_entity.dart';
import 'package:fluttalk/domain/entities/me_entity.dart';
import 'package:fluttalk/gen/assets.gen.dart';
import 'package:fluttalk/presentation/components/bottom_sheet/edit_chat_title_bottom_sheet.dart';
import 'package:fluttalk/presentation/components/bottom_sheet/select_friend_bottom_sheet.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:fluttalk/presentation/theme/my_text_styles.dart';
import 'package:flutter/material.dart';

class ChatListSliverAppBar extends StatelessWidget {
  final Function(FriendEntity me, String title) onCreateChat;
  const ChatListSliverAppBar({
    super.key,
    required this.onCreateChat,
  });

  _showChatTitleBottomSheet(BuildContext context, FriendEntity friend) async {
    final title = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: false,
      builder: (bottomSheetContext) => const EditChatTitleBottomSheet(),
    );
    if (title != null) {
      onCreateChat(friend, title);
    }
  }

  _showFriendsBottomSheet(BuildContext context) async {
    final friend = await showModalBottomSheet<FriendEntity>(
      context: context,
      isScrollControlled: false,
      builder: (bottomSheetContext) => const SelectFriendBottomSheet(),
    );
    if (friend != null && context.mounted) {
      _showChatTitleBottomSheet(context, friend);
    }
  }

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
            onTap: () => _showFriendsBottomSheet(context),
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
