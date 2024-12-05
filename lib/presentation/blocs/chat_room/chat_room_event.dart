import 'package:fluttalk/domain/entities/chat_entity.dart';
import 'package:fluttalk/domain/entities/message_entity.dart';

sealed class ChatRoomEvent {}

class LoadMoreMessagesEvent extends ChatRoomEvent {}

class RefreshMessagesEvent extends ChatRoomEvent {}

class NewMessagesReceivedEvent extends ChatRoomEvent {
  final List<MessageEntity> messages;
  NewMessagesReceivedEvent(this.messages);
}

class ChatUpdatedEvent extends ChatRoomEvent {
  final ChatEntity chat;
  ChatUpdatedEvent(this.chat);
}

class SendMessageEvent extends ChatRoomEvent {
  final String content;
  SendMessageEvent(this.content);
}
