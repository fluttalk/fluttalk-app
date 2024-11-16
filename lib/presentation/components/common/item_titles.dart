import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:fluttalk/presentation/theme/my_text_styles.dart';
import 'package:flutter/material.dart';

class ItemTitles extends StatelessWidget {
  final String main;
  final String sub;
  const ItemTitles({
    required this.main,
    required this.sub,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            main,
            style: MyTextStyles.bodyText1.copyWith(
              color: MyColors.neutralActive,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: MyTextStyles.metaData1.copyWith(
              color: MyColors.neutralDisabled,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
