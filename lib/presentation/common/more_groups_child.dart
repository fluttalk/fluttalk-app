import 'package:fluttalk/gen/assets.gen.dart';

enum MoreGroupsChild {
  privacy,
  help,
}

sealed class MoreItemData {}

class MoreUserItemData implements MoreItemData {
  final String name;
  final String email;
  const MoreUserItemData({
    required this.name,
    required this.email,
  });
}

class MoreGroupItemData implements MoreItemData {
  final List<MoreGroupsChild> children;
  const MoreGroupItemData({required this.children});
}

class MoreSeperatorItemData implements MoreItemData {}

extension MoreGroupChildsExtension on MoreGroupsChild {
  String get title => {
        MoreGroupsChild.privacy: 'Privacy',
        MoreGroupsChild.help: 'Help',
      }[this]!;

  AssetGenImage get assetGenImage => {
        MoreGroupsChild.privacy: Assets.icons.outlinePrivacyTip,
        MoreGroupsChild.help: Assets.icons.helpCircle,
      }[this]!;
}
