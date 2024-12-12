import 'dart:async';

import 'package:fluttalk/domain/entities/chat_entity.dart';
import 'package:fluttalk/domain/services/chat_service.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';
import 'package:fluttalk/presentation/blocs/chat_list/chat_list_event.dart';
import 'package:fluttalk/presentation/blocs/chat_list/chat_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fluttalk/core/error/error.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatService _chatService;
  final Map<String, StreamSubscription<Either<AppException, ChatEntity>>>
      _chatSubscriptions = {};

  ChatListBloc({required ChatService chatService})
      : _chatService = chatService,
        super(const ChatListState()) {
    on<LoadMoreChatsEvent>(_onLoadMore);
    on<RefreshChatsEvent>(_onRefresh);
    on<ChatUpdatedEvent>(_onChatUpdated);
    on<CreateChatEvent>(_onCreateChat);

    // 초기 로딩 시작
    add(LoadMoreChatsEvent());
  }

  Future<void> _onLoadMore(
    LoadMoreChatsEvent event,
    Emitter<ChatListState> emit,
  ) async {
    // 이미 로딩 중이거나 더 로드할 수 없다면 중단
    if (state.chats is AsyncLoading || !state.hasMore) return;

    final currentChats = switch (state.chats) {
      AsyncData(data: final chats) => chats,
      _ => <ChatEntity>[],
    };

    // 첫 로드가 아니면 현재 목록 유지, 아니면 로딩 표시
    if (currentChats.isEmpty) {
      emit(state.copyWith(chats: const AsyncLoading()));
    } else {
      emit(state.copyWith(chats: AsyncData(currentChats)));
    }

    final result = await _chatService.getChats(startAt: state.nextKey);
    result.fold(
      (error) => emit(state.copyWith(
        chats: AsyncError(error.message),
        error: error.message,
      )),
      (pagedChats) {
        final newChats = [...currentChats, ...pagedChats.items];
        emit(state.copyWith(
          chats: AsyncData(newChats),
          hasMore: pagedChats.nextKey != null,
          nextKey: pagedChats.nextKey,
          error: null,
        ));

        // 새로 로드한 챗들에 대해 watchChat 구독 시작
        _subscribeToAllChats(newChats);
      },
    );
  }

  Future<void> _onRefresh(
    RefreshChatsEvent event,
    Emitter<ChatListState> emit,
  ) async {
    // 기존 구독 정리
    await _cancelAllChatSubscriptions();

    // 상태 초기화 후 다시 로드
    emit(const ChatListState());
    add(LoadMoreChatsEvent());
  }

  Future<void> _onChatUpdated(
    ChatUpdatedEvent event,
    Emitter<ChatListState> emit,
  ) async {
    final currentChats = switch (state.chats) {
      AsyncData(data: final chats) => chats,
      _ => <ChatEntity>[],
    };

    final index = currentChats.indexWhere((chat) => chat.id == event.chat.id);

    if (index != -1) {
      final updatedChats = [...currentChats];
      updatedChats.removeAt(index);
      // lastMessage가 있으면 리스트 맨 앞으로 이동(최신 대화방)
      if (event.chat.lastMessage != null) {
        updatedChats.insert(0, event.chat);
      } else {
        updatedChats.insert(index, event.chat);
      }

      emit(state.copyWith(chats: AsyncData(updatedChats)));
    } else {
      // 목록에 없는 신규 채팅방이 실시간 업데이트되었다면 추가 로직 필요 (상황에 따라)
    }
  }

  Future<void> _onCreateChat(
    CreateChatEvent event,
    Emitter<ChatListState> emit,
  ) async {
    final result = await _chatService.createChat(
      email: event.email,
      title: event.title,
    );

    result.fold(
      (error) => emit(state.copyWith(error: error.message)),
      (newChat) {
        final currentChats = switch (state.chats) {
          AsyncData(data: final chats) => chats,
          _ => <ChatEntity>[],
        };

        final updatedChats = [newChat, ...currentChats];
        emit(state.copyWith(
          chats: AsyncData(updatedChats),
          error: null,
          createdChat: newChat,
        ));

        // 새로 생성한 챗에 대해 watchChat 구독 시작
        _subscribeToChat(newChat.id);

        emit(state.copyWith(createdChat: null));
      },
    );
  }

  void _subscribeToAllChats(List<ChatEntity> chats) {
    for (final chat in chats) {
      // 이미 구독 중이면 스킵
      if (_chatSubscriptions.containsKey(chat.id)) continue;
      _subscribeToChat(chat.id);
    }
  }

  void _subscribeToChat(String chatId) {
    final subscription = _chatService.watchChat(chatId).listen((result) {
      result.fold(
        (error) {
          // 에러 발생 시 별도 처리 필요하면 추가
          // 여기서는 무시
        },
        (updatedChat) {
          // 채팅방 변경 시 ChatUpdatedEvent 발생
          add(ChatUpdatedEvent(updatedChat));
        },
      );
    });

    _chatSubscriptions[chatId] = subscription;
  }

  Future<void> _cancelAllChatSubscriptions() async {
    final futures = _chatSubscriptions.values.map((sub) => sub.cancel());
    await Future.wait(futures);
    _chatSubscriptions.clear();
  }

  @override
  Future<void> close() async {
    await _cancelAllChatSubscriptions();
    return super.close();
  }
}
