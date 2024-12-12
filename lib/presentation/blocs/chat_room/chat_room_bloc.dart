import 'dart:async';

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

    // 블록 생성 시 채팅방 구독 시작
    // _startWatching();
    _initializeChat();
  }

  // void _startWatching() {
  //   _chatSubscription = _chatService.watchChat(chatId).listen((result) {
  //     result.fold(
  //       (error) => null,
  //       (chat) => add(ChatUpdatedEvent(chat)),
  //     );
  //   });
  // }
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

    if (currentMessages.isNotEmpty) {
      emit(state.copyWith(messages: AsyncData(currentMessages)));
    } else {
      emit(state.copyWith(messages: const AsyncLoading()));
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
        final newMessages = [...currentMessages, ...pagedMessages.items];
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

    final updatedMessages = [...event.messages, ...currentMessages];
    emit(state.copyWith(
      messages: AsyncData(updatedMessages),
      error: null,
    ));
  }

  Future<void> _onChatUpdated(
    ChatUpdatedEvent event,
    Emitter<ChatRoomState> emit,
  ) async {
    // 우선 채팅방 정보를 상태에 반영합니다.
    emit(state.copyWith(chat: event.chat));

    // 현재 로드된 메시지 목록을 가져옵니다.
    final currentMessages = switch (state.messages) {
      AsyncData(data: final messages) => messages,
      _ => <MessageEntity>[],
    };

    // 메시지가 하나도 없다면 (첫 로드) 메시지 로드를 시작합니다.
    if (currentMessages.isEmpty) {
      add(LoadMoreMessagesEvent());
      return;
    }

    // lastMessage가 있고 새 메시지가 도착했을 때만 처리합니다.
    if (event.chat.lastMessage != null) {
      // 모든 이전 메시지를 로드했는지 확인합니다.
      if (!state.hasMore) {
        // 마지막으로 받은 메시지 이후의 새 메시지들을 요청합니다.
        final result = await _messageService.getNewMessages(
          chatId: chatId,
          lastNewestSentAt: currentMessages.first.sentAt.millisecondsSinceEpoch,
        );

        result.fold(
          // 에러가 발생하면 상태에 에러 메시지를 저장합니다.
          (error) => emit(state.copyWith(error: error.message)),
          // 새 메시지가 있다면 현재 목록 앞에 추가합니다.
          (newMessages) {
            if (newMessages.isEmpty) return;

            final updatedMessages = [...newMessages, ...currentMessages];
            emit(state.copyWith(
              messages: AsyncData(updatedMessages),
              error: null,
            ));
          },
        );
      } else {
        // 아직 이전 메시지가 더 있다면, 새로고침하여 처음부터 다시 로드합니다.
        // 이는 메시지의 연속성을 보장하기 위함입니다.
        emit(ChatRoomState(chat: state.chat)); // 상태 초기화 (채팅방 정보는 유지)
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
        if (state.messages case AsyncData(data: final messages)) {
          emit(state.copyWith(
            messages: AsyncData([message, ...messages]),
            error: null,
          ));
        } else {
          emit(state.copyWith(
            messages: AsyncData([message]),
            error: null,
          ));
        }
      },
    );
  }

  @override
  Future<void> close() async {
    await _chatSubscription?.cancel();
    await super.close();
  }
}
