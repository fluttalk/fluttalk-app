import 'dart:async';

import 'package:fluttalk/domain/entities/chat_entity.dart';
import 'package:fluttalk/domain/entities/message_entity.dart';
import 'package:fluttalk/domain/services/chat_service.dart';
import 'package:fluttalk/domain/services/message_service.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';
import 'package:fluttalk/presentation/blocs/chat_room/chat_room_event.dart';
import 'package:fluttalk/presentation/blocs/chat_room/chat_room_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final MessageService _messageService;
  final ChatService _chatService;
  final String chatId;
  StreamSubscription? _chatSubscription;

  ChatRoomBloc({
    required MessageService messageService,
    required ChatService chatService,
    required this.chatId,
  })  : _messageService = messageService,
        _chatService = chatService,
        super(const ChatRoomState()) {
    on<LoadMoreMessagesEvent>(_onLoadMore);
    on<RefreshMessagesEvent>(_onRefresh);
    on<NewMessagesReceivedEvent>(_onNewMessages);
    on<ChatUpdatedEvent>(_onChatUpdated);
    on<SendMessageEvent>(_onSendMessage);

    _initializeChat();
  }

  void _sortMessagesBySentAt(List<MessageEntity> messages) {
    messages.sort((a, b) => a.sentAt.compareTo(b.sentAt));
  }

  Future<void> _initializeChat() async {
    // 채팅방 구독 시작
    _chatSubscription = _chatService.watchChat(chatId).listen((result) {
      result.fold(
        (error) => null,
        (chat) => add(ChatUpdatedEvent(chat)),
      );
    });
    // 초기 메시지 로드
    add(LoadMoreMessagesEvent());
  }

  Future<void> _onLoadMore(
    LoadMoreMessagesEvent event,
    Emitter<ChatRoomState> emit,
  ) async {
    if (state.messages is AsyncLoading || !state.hasMore) return;

    final currentMessages = switch (state.messages) {
      AsyncData(data: final messages) => messages,
      _ => <MessageEntity>[],
    };

    if (currentMessages.isEmpty) {
      emit(state.copyWith(messages: const AsyncLoading()));
    } else {
      emit(state.copyWith(messages: AsyncData(currentMessages)));
    }

    final result = await _messageService.getMessages(
      chatId: chatId,
      startAt: state.nextKey,
    );

    result.fold(
      (error) => emit(state.copyWith(
        messages: AsyncError(error.message),
        error: error.message,
      )),
      (pagedMessages) {
        // 오래된 메시지를 앞에 추가
        final newMessages = [...pagedMessages.items, ...currentMessages];

        // 정렬 적용: 오래된 메시지부터 최신 메시지까지 순서 보장
        _sortMessagesBySentAt(newMessages);

        emit(state.copyWith(
          messages: AsyncData(newMessages),
          hasMore: pagedMessages.nextKey != null,
          nextKey: pagedMessages.nextKey,
          error: null,
        ));
      },
    );
  }

  Future<void> _onRefresh(
    RefreshMessagesEvent event,
    Emitter<ChatRoomState> emit,
  ) async {
    emit(ChatRoomState(chat: state.chat));
    add(LoadMoreMessagesEvent());
  }

  Future<void> _onNewMessages(
    NewMessagesReceivedEvent event,
    Emitter<ChatRoomState> emit,
  ) async {
    final currentMessages = switch (state.messages) {
      AsyncData(data: final messages) => messages,
      _ => <MessageEntity>[],
    };

    // 새 메시지 뒤쪽에 추가
    final updatedMessages = [...currentMessages, ...event.messages];

    // 정렬 적용
    _sortMessagesBySentAt(updatedMessages);

    emit(state.copyWith(
      messages: AsyncData(updatedMessages),
      error: null,
    ));
  }

  Future<void> _onChatUpdated(
    ChatUpdatedEvent event,
    Emitter<ChatRoomState> emit,
  ) async {
    // 채팅방 정보 업데이트
    emit(state.copyWith(chat: event.chat));

    final currentMessages = switch (state.messages) {
      AsyncData(data: final messages) => messages,
      _ => <MessageEntity>[],
    };

    // 메시지가 없으면 메시지 로드
    if (currentMessages.isEmpty) {
      add(LoadMoreMessagesEvent());
      return;
    }

    // lastMessage 업데이트 시 새 메시지 확인
    if (event.chat.lastMessage != null) {
      if (!state.hasMore) {
        // 모든 이전 메시지를 로드한 상태라면 새로운 메시지 요청
        final result = await _messageService.getNewMessages(
          chatId: chatId,
          lastNewestSentAt: currentMessages.last.sentAt.millisecondsSinceEpoch,
        );

        result.fold(
          (error) => emit(state.copyWith(error: error.message)),
          (newMessages) {
            if (newMessages.isEmpty) return;

            final updatedMessages = [...currentMessages, ...newMessages];
            _sortMessagesBySentAt(updatedMessages);

            emit(state.copyWith(
              messages: AsyncData(updatedMessages),
              error: null,
            ));
          },
        );
      } else {
        // 이전 메시지가 더 있다면 다시 로딩
        emit(ChatRoomState(chat: state.chat));
        add(LoadMoreMessagesEvent());
      }
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatRoomState> emit,
  ) async {
    final result = await _messageService.sendMessage(
      chatId: chatId,
      content: event.content,
    );

    result.fold(
      (error) => emit(state.copyWith(error: error.message)),
      (message) {
        final currentMessages = switch (state.messages) {
          AsyncData(data: final messages) => messages,
          _ => <MessageEntity>[],
        };

        final updatedMessages = [...currentMessages, message];
        _sortMessagesBySentAt(updatedMessages);

        emit(state.copyWith(
          messages: AsyncData(updatedMessages),
          error: null,
        ));
      },
    );
  }

  @override
  Future<void> close() async {
    await _chatSubscription?.cancel();
    await super.close();
  }
}
