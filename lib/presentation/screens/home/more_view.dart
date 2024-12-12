import 'package:fluttalk/presentation/components/more/more_group_item.dart';
import 'package:fluttalk/presentation/components/more/more_logout_item.dart';
import 'package:fluttalk/presentation/components/more/more_seperator_item.dart';
import 'package:fluttalk/presentation/components/more/more_sliver_app_bar.dart';
import 'package:fluttalk/presentation/components/more/more_user_item.dart';
import 'package:flutter/material.dart';

class MoreView extends StatelessWidget {
  static List<MoreItemData> items = [
    const MoreUserItemData(),
    const MoreGroupItemData(children: [
      MoreGroupsChild.help,
      MoreGroupsChild.privacy,
    ]),
    MoreSeperatorItemData(),
    MoreLogoutItemData(),
  ];

  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const MoreSliverAppBar(),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => switch (items[index]) {
              MoreUserItemData _ => const MoreUserItem(),
              MoreGroupItemData data => MoreGroupItem(data: data),
              MoreSeperatorItemData _ => const MoreSeperatorItem(),
              MoreLogoutItemData _ => const MoreLogoutItem(),
            },
            childCount: items.length,
          ),
        ),
      ],
    );
  }
}
