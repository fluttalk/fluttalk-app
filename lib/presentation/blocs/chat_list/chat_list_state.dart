import 'package:fluttalk/domain/entities/chat_entity.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';

class ChatListState {
  final AsyncValue<List<ChatEntity>> chats;
  final bool hasMore;
  final String? nextKey;
  final String? error;
  final ChatEntity? createdChat; // 새로 추가

  const ChatListState({
    this.chats = const AsyncInitial(),
    this.hasMore = true,
    this.nextKey,
    this.error,
    this.createdChat,
  });

  ChatListState copyWith({
    AsyncValue<List<ChatEntity>>? chats,
    bool? hasMore,
    String? nextKey,
    String? error,
    ChatEntity? createdChat,
  }) {
    return ChatListState(
      chats: chats ?? this.chats,
      hasMore: hasMore ?? this.hasMore,
      nextKey: nextKey,
      error: error,
      createdChat: createdChat,
    );
  }
}
