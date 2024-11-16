import 'package:fluttalk/presentation/common/bottom_navigation_items.dart';
import 'package:fluttalk/presentation/components/home_bottom_navigation_bar.dart';
import 'package:fluttalk/presentation/screens/home/friend_list_screen.dart';
import 'package:fluttalk/presentation/screens/home/chat_list_screen.dart';
import 'package:fluttalk/presentation/screens/home/more_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final navigationItemNotifer =
      ValueNotifier<BottomNavigationItems>(BottomNavigationItems.friendList);
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: HomeBottonNavigationBar(navigationItemNotifer),
      body: ValueListenableBuilder(
        valueListenable: navigationItemNotifer,
        builder: (context, value, child) => switch (value) {
          BottomNavigationItems.friendList => const FriendListScreen(),
          BottomNavigationItems.chatList => const ChatListScreen(),
          BottomNavigationItems.more => const MoreScreen()
        },
      ),
    );
  }
}
