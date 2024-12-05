import 'package:fluttalk/data/models/chat_model.dart';
import 'package:fluttalk/domain/entities/message_entity.dart';

class ChatEntity {
  final String id;
  final String title;
  final List<String> members;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MessageEntity? lastMessage;

  const ChatEntity({
    required this.id,
    required this.title,
    required this.members,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
  });

  factory ChatEntity.from(ChatModel model) {
    // timestamp(milliseconds)를 DateTime으로 변환
    return ChatEntity(
      id: model.id,
      title: model.title,
      members: model.members,
      createdAt: DateTime.fromMillisecondsSinceEpoch(model.createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(model.updatedAt),
      lastMessage: model.lastMessage != null
          ? MessageEntity.from(model.lastMessage!)
          : null,
    );
  }
}
