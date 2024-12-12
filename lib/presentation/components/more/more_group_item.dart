import 'package:fluttalk/gen/assets.gen.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:fluttalk/presentation/theme/my_text_styles.dart';
import 'package:flutter/material.dart';

enum MoreGroupsChild {
  privacy,
  help,
}

sealed class MoreItemData {}

class MoreUserItemData implements MoreItemData {
  const MoreUserItemData();
}

class MoreGroupItemData implements MoreItemData {
  final List<MoreGroupsChild> children;
  const MoreGroupItemData({required this.children});
}

class MoreSeperatorItemData implements MoreItemData {}

class MoreLogoutItemData implements MoreItemData {}

extension MoreGroupChildsExtension on MoreGroupsChild {
  String get title => {
        MoreGroupsChild.privacy: '개인 정보 처리 방침',
        MoreGroupsChild.help: '도움말',
      }[this]!;

  AssetGenImage get assetGenImage => {
        MoreGroupsChild.privacy: Assets.icons.outlinePrivacyTip,
        MoreGroupsChild.help: Assets.icons.helpCircle,
      }[this]!;
}

class MoreGroupChildItem extends StatelessWidget {
  final MoreGroupsChild moreGroupChild;
  const MoreGroupChildItem(this.moreGroupChild, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Center(
              child: moreGroupChild.assetGenImage.image(scale: 2),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              moreGroupChild.title,
              style: MyTextStyles.bodyText1.copyWith(
                color: MyColors.neutralActive,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 6),
          InkWell(child: Assets.icons.chevronRight.image(scale: 2))
        ],
      ),
    );
  }
}

class MoreGroupItem extends StatelessWidget {
  final MoreGroupItemData data;
  const MoreGroupItem({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          const SizedBox(height: 8),
          ...data.children.map((child) {
            return Column(
              children: [
                MoreGroupChildItem(child),
                const SizedBox(height: 8),
              ],
            );
          }),
        ],
      ),
    );
  }
}
