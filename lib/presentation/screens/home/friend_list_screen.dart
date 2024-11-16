import 'package:fluttalk/presentation/components/friend_list/friend_list_item.dart';
import 'package:fluttalk/presentation/components/common/search_text_field.dart';
import 'package:fluttalk/presentation/components/friend_list/friend_list_sliver_app_bar.dart';
import 'package:flutter/material.dart';

class FriendListScreen extends StatelessWidget {
  const FriendListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const FriendListSliverAppBar(),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => switch (index) {
              0 => const SearchTextField(placeholder: "Search"),
              _ => const FriendListItem(),
            },
            childCount: 20,
          ),
        ),
      ],
    );
  }
}
