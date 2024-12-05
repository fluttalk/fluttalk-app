import 'package:fluttalk/domain/entities/chat_entity.dart';

sealed class ChatListEvent {}

class LoadMoreChatsEvent extends ChatListEvent {}

class RefreshChatsEvent extends ChatListEvent {}

class ChatUpdatedEvent extends ChatListEvent {
  final ChatEntity chat;
  ChatUpdatedEvent(this.chat);
}

class CreateChatEvent extends ChatListEvent {
  final String email;
  final String title;
  CreateChatEvent({required this.email, required this.title});
}
