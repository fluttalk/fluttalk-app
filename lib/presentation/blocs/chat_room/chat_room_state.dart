import 'package:fluttalk/domain/entities/chat_entity.dart';
import 'package:fluttalk/domain/entities/message_entity.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';

class ChatRoomState {
  // 메시지 목록과 관련된 상태
  final AsyncValue<List<MessageEntity>> messages;
  final bool hasMore;
  final String? nextKey;

  // 채팅방 정보 상태
  final ChatEntity? chat;
  final String? error;

  const ChatRoomState({
    this.messages = const AsyncInitial(),
    this.hasMore = true,
    this.nextKey,
    this.chat,
    this.error,
  });

  ChatRoomState copyWith({
    AsyncValue<List<MessageEntity>>? messages,
    bool? hasMore,
    String? nextKey,
    ChatEntity? chat,
    String? error,
  }) {
    return ChatRoomState(
      messages: messages ?? this.messages,
      hasMore: hasMore ?? this.hasMore,
      nextKey: nextKey,
      chat: chat ?? this.chat,
      error: error,
    );
  }
}
