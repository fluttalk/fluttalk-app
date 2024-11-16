import 'package:fluttalk/presentation/common/more_groups_child.dart';
import 'package:fluttalk/presentation/components/more/more_group_item.dart';
import 'package:fluttalk/presentation/components/more/more_seperator_item.dart';
import 'package:fluttalk/presentation/components/more/more_user_item.dart';
import 'package:fluttalk/presentation/components/more/more_sliver_app_bar.dart';
import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  static List<MoreItemData> items = [
    const MoreUserItemData(
      name: "최재영",
      email: "qwerty@gmail.com",
    ),
    const MoreGroupItemData(children: [
      MoreGroupsChild.help,
      MoreGroupsChild.privacy,
    ]),
    MoreSeperatorItemData(),
    const MoreGroupItemData(children: [
      MoreGroupsChild.help,
      MoreGroupsChild.privacy,
    ]),
  ];

  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const MoreSliverAppBar(),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => switch (items[index]) {
              MoreUserItemData data => MoreUserItem(data: data),
              MoreGroupItemData data => MoreGroupItem(data: data),
              MoreSeperatorItemData _ => const MoreSeperatorItem(),
            },
            childCount: items.length,
          ),
        ),
      ],
    );
  }
}
