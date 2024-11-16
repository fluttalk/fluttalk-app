import 'package:fluttalk/gen/assets.gen.dart';
import 'package:fluttalk/presentation/common/more_groups_child.dart';
import 'package:fluttalk/presentation/components/common/item_titles.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class MoreUserItem extends StatelessWidget {
  final MoreUserItemData data;
  const MoreUserItem({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: MyColors.neutralLine,
            ),
            child: Center(
              child: Assets.icons.user.image(
                scale: 2,
              ),
            ),
          ),
          const SizedBox(width: 16),
          ItemTitles(
            main: data.name,
            sub: data.email,
          ),
          const SizedBox(width: 6),
          InkWell(
            child: Assets.icons.chevronRight.image(scale: 2),
          )
        ],
      ),
    );
  }
}
