import 'dart:async';

import 'package:fluttalk/domain/entities/chat_entity.dart';
import 'package:fluttalk/domain/services/chat_service.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';
import 'package:fluttalk/presentation/blocs/chat_list/chat_list_event.dart';
import 'package:fluttalk/presentation/blocs/chat_list/chat_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatService _chatService;
  // StreamSubscription? _chatSubscription;

  ChatListBloc({
    required ChatService chatService,
  })  : _chatService = chatService,
        super(const ChatListState()) {
    on<LoadMoreChatsEvent>(_onLoadMore);
    on<RefreshChatsEvent>(_onRefresh);
    on<ChatUpdatedEvent>(_onChatUpdated);
    on<CreateChatEvent>(_onCreateChat);

    // 블록 생성 시 채팅방 목록 로드 시작
    add(LoadMoreChatsEvent());
  }

  Future<void> _onLoadMore(
    LoadMoreChatsEvent event,
    Emitter<ChatListState> emit,
  ) async {
    // 이미 로딩 중이거나 더 불러올 항목이 없으면 중단
    if (state.chats is AsyncLoading || !state.hasMore) return;

    // 현재 채팅방 목록을 가져옵니다
    final currentChats = switch (state.chats) {
      AsyncData(data: final chats) => chats,
      _ => <ChatEntity>[],
    };

    // 첫 로드가 아니면 현재 목록 유지, 아니면 로딩 상태로 전환
    if (currentChats.isNotEmpty) {
      emit(state.copyWith(chats: AsyncData(currentChats)));
    } else {
      emit(state.copyWith(chats: const AsyncLoading()));
    }

    // 새로운 채팅방 목록을 로드합니다
    final result = await _chatService.getChats(startAt: state.nextKey);
    print(result);
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
      },
    );
  }

  Future<void> _onRefresh(
    RefreshChatsEvent event,
    Emitter<ChatListState> emit,
  ) async {
    // 상태를 초기화하고 처음부터 다시 로드
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

    // 업데이트된 채팅방의 위치를 찾습니다
    final index = currentChats.indexWhere((chat) => chat.id == event.chat.id);

    if (index != -1) {
      // 채팅방이 이미 목록에 있으면 업데이트하고 최신 메시지가 있으면 맨 위로 이동
      final updatedChats = [...currentChats];
      updatedChats.removeAt(index);

      // 새 메시지가 있으면 맨 위로, 아니면 원래 위치로
      if (event.chat.lastMessage != null) {
        updatedChats.insert(0, event.chat);
      } else {
        updatedChats.insert(index, event.chat);
      }

      emit(state.copyWith(chats: AsyncData(updatedChats)));
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

        // 새로운 채팅방을 맨 위에 추가
        emit(state.copyWith(
          chats: AsyncData([newChat, ...currentChats]),
          error: null,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    // _chatSubscription?.cancel();
    return super.close();
  }
}
