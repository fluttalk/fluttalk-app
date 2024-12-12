import 'package:fluttalk/core/common/utility.dart';
import 'package:fluttalk/domain/entities/chat_entity.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:fluttalk/presentation/theme/my_text_styles.dart';
import 'package:flutter/material.dart';

class ChatListItemMetadata extends StatelessWidget {
  final ChatEntity chat;
  const ChatListItemMetadata({
    required this.chat,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            chat.updatedAt.differentTimeDisplayText,
            style: MyTextStyles.metaData2.copyWith(
              color: MyColors.neutralWeak,
            ),
          ),
        ],
      ),
    );
  }
}


// class ChatListItemMetadata extends StatelessWidget {
//   const ChatListItemMetadata({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 48,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Text(
//             "Today",
//             style: MyTextStyles.metaData2.copyWith(
//               color: MyColors.neutralWeak,
//             ),
//           ),
//           Container(
//             width: 20,
//             height: 20,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(40),
//               color: MyColors.brandBG,
//             ),
//             child: Center(
//               child: Text(
//                 "99",
//                 style: MyTextStyles.metaData2.copyWith(
//                   color: MyColors.brandDark,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
