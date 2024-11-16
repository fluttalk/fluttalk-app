import 'package:fluttalk/presentation/components/chat_room/chat_room_message_text_field.dart';
import 'package:fluttalk/presentation/components/chat_room/chat_room_sliver_app_bar.dart';
import 'package:flutter/material.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                ChatRoomSliverAppBar(),
                SliverToBoxAdapter(
                  child: Placeholder(),
                ),
                SliverToBoxAdapter(
                  child: Placeholder(),
                ),
                SliverToBoxAdapter(
                  child: Placeholder(),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: ChatRoomMessageTextField.height),
                ),
              ],
            ),
            ChatRoomMessageTextField(),
          ],
        ),
      ),
    );
  }
}
