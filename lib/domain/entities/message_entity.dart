import 'package:fluttalk/data/models/message_model.dart';

class MessageEntity {
  final String chatId;
  final String senderId;
  final String content;
  final DateTime sentAt;

  const MessageEntity({
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.sentAt,
  });

  factory MessageEntity.from(MessageModel model) {
    return MessageEntity(
      chatId: model.chatId,
      senderId: model.sender,
      content: model.content,
      // timestamp(milliseconds)를 DateTime으로 변환
      sentAt: DateTime.fromMillisecondsSinceEpoch(model.sentAt),
    );
  }
}
