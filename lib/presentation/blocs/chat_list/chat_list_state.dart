import 'package:fluttalk/domain/entities/chat_entity.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';

class ChatListState {
  final AsyncValue<List<ChatEntity>> chats;
  final bool hasMore;
  final String? nextKey;
  final String? error;

  const ChatListState({
    this.chats = const AsyncInitial(),
    this.hasMore = true,
    this.nextKey,
    this.error,
  });

  ChatListState copyWith({
    AsyncValue<List<ChatEntity>>? chats,
    bool? hasMore,
    String? nextKey,
    String? error,
  }) {
    return ChatListState(
      chats: chats ?? this.chats,
      hasMore: hasMore ?? this.hasMore,
      nextKey: nextKey,
      error: error,
    );
  }
}
