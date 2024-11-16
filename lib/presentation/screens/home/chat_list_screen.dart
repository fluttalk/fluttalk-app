import 'package:fluttalk/presentation/components/chat_list/chat_list_item.dart';
import 'package:fluttalk/presentation/components/chat_list/chat_list_sliver_app_bar.dart';
import 'package:fluttalk/presentation/components/common/search_text_field.dart';
import 'package:fluttalk/presentation/screens/chat_room/chat_room_screen.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  _onTap(BuildContext context, int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return const ChatRoomScreen();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const ChatListSliverAppBar(),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => switch (index) {
              0 => const SearchTextField(placeholder: "Search"),
              _ => ChatListItem(
                  onTap: () => _onTap(context, index),
                ),
            },
            childCount: 20,
          ),
        ),
      ],
    );
  }
}
