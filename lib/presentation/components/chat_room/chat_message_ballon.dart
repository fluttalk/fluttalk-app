import 'package:fluttalk/domain/entities/message_entity.dart';
import 'package:fluttalk/presentation/theme/my_colors.dart';
import 'package:fluttalk/presentation/theme/my_text_styles.dart';
import 'package:flutter/material.dart';

class ChatMessageBalloon extends StatelessWidget {
  final MessageEntity message;
  final bool isUsers;
  const ChatMessageBalloon({
    required this.isUsers,
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment:
            isUsers ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.8),
            decoration: BoxDecoration(
              color: isUsers ? MyColors.brandDefault : MyColors.neutralOffWhite,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isUsers ? const Radius.circular(16) : Radius.zero,
                bottomRight: isUsers ? Radius.zero : const Radius.circular(16),
              ),
            ),
            child: Text(
              message.content,
              softWrap: true,
              style: MyTextStyles.bodyText2.copyWith(
                color:
                    isUsers ? MyColors.neutralOffWhite : MyColors.neutralActive,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
