import 'package:fluttalk/domain/entities/chat_entity.dart';
import 'package:fluttalk/presentation/components/common/item_titles.dart';
import 'package:fluttalk/presentation/components/chat_list/chat_list_item_metadata.dart';
import 'package:fluttalk/presentation/components/common/profile_thumbnail.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class ChatListItem extends StatelessWidget {
  final ChatEntity chat;
  final Function(ChatEntity chat) onTap;

  const ChatListItem({
    required this.chat,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(chat),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ProfileThumbnail(),
                const SizedBox(width: 12),
                ItemTitles(
                    main: chat.title, sub: chat.lastMessage?.content ?? ''),
                const SizedBox(width: 4),
                const ChatListItemMetadata(),
              ],
            ),
            const SizedBox(height: 12.5),
            Container(
              height: 1,
              color: MyColors.neutralLine,
            ),
          ],
        ),
      ),
    );
  }
}
