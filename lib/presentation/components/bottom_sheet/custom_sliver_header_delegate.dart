import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class CustomSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  CustomSliverHeaderDelegate({required this.widget});

  Widget widget;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: widget,
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: MyColors.neutralLine,
        ),
      ],
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
