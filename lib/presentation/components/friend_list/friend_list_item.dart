import 'package:fluttalk/domain/entities/friend_entity.dart';
import 'package:fluttalk/presentation/components/common/item_titles.dart';
import 'package:fluttalk/presentation/components/common/profile_thumbnail.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class FriendListItem extends StatelessWidget {
  final FriendEntity friend;
  final Function(FriendEntity friend) onTap;

  const FriendListItem({
    super.key,
    required this.friend,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(friend),
        child: Container(
          padding: const EdgeInsets.only(top: 8, left: 24, right: 24),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ProfileThumbnail(),
                  const SizedBox(width: 12),
                  ItemTitles(
                    main: friend.name ?? '없음',
                    sub: friend.email,
                  ),
                ],
              ),
              const SizedBox(height: 12.5),
              Container(
                height: 1,
                color: MyColors.neutralLine,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class FriendListItem extends StatelessWidget {
//   const FriendListItem({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const ProfileThumbnail(),
//               const SizedBox(width: 12),
//               ItemTitles(
//                 main: "일이삼사오육칠팔구십" * 3,
//                 sub: "일이삼사오육칠팔구십" * 3,
//               ),
//             ],
//           ),
//           const SizedBox(height: 12.5),
//           Container(
//             height: 1,
//             color: MyColors.neutralLine,
//           ),
//         ],
//       ),
//     );
//   }
// }
