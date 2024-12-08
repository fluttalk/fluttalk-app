import 'dart:async';

import 'package:fluttalk/domain/entities/chat_entity.dart';
import 'package:fluttalk/domain/entities/friend_entity.dart';
import 'package:fluttalk/domain/entities/me_entity.dart';
import 'package:fluttalk/domain/services/chat_service.dart';
import 'package:fluttalk/domain/services/message_service.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';
import 'package:fluttalk/presentation/blocs/chat_list/chat_list_bloc.dart';
import 'package:fluttalk/presentation/blocs/chat_list/chat_list_event.dart';
import 'package:fluttalk/presentation/blocs/chat_list/chat_list_state.dart';
import 'package:fluttalk/presentation/blocs/chat_room/chat_room_bloc.dart';
import 'package:fluttalk/presentation/blocs/chat_room/chat_room_event.dart';
import 'package:fluttalk/presentation/components/chat_list/chat_list_item.dart';
import 'package:fluttalk/presentation/components/chat_list/chat_list_sliver_app_bar.dart';
import 'package:fluttalk/presentation/components/common/search_text_field.dart';
import 'package:fluttalk/presentation/screens/chat_room/chat_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({super.key});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<ChatListBloc>().add(LoadMoreChatsEvent());
    }
  }

  void _onSearchChanged() {
    setState(() {
      // 상태를 갱신하여 UI를 재렌더링합니다.
    });
  }

  List<ChatEntity> _getFilteredChats(List<ChatEntity> chats) {
    final query = _searchController.text;
    if (query.isEmpty) return chats;

    return chats
        .where((chat) => chat.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> _onRefresh() async {
    final completer = Completer<void>();

    late final StreamSubscription<ChatListState> subscription;
    subscription = context.read<ChatListBloc>().stream.listen((state) {
      if (state.chats is! AsyncLoading) {
        completer.complete();
        subscription.cancel();
      }
    });

    context.read<ChatListBloc>().add(RefreshChatsEvent());

    return completer.future;
  }

  _createChat(BuildContext context, FriendEntity friend, String title) async {
    final chatService = context.read<ChatService>();
    final messageService = context.read<MessageService>();

    final bloc = context.read<ChatListBloc>();
    final previousChats = bloc.state.chats;

    bloc.add(CreateChatEvent(
      email: friend.email,
      title: title,
    ));

    // 새로운 채팅방이 생성될 때까지 대기
    await for (final state in bloc.stream) {
      if (!context.mounted) return;

      // 에러가 있으면 표시
      if (state.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error!)),
        );
        break;
      }

      // 새로운 채팅방이 추가되었는지 확인
      if (state.chats is AsyncData) {
        final currentChats = (state.chats as AsyncData<List<ChatEntity>>).data;
        if (previousChats is AsyncData) {
          final prevChatList =
              (previousChats as AsyncData<List<ChatEntity>>).data;
          if (currentChats.length > prevChatList.length) {
            // 새로운 채팅방으로 이동
            final newChat = currentChats.first;
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => ChatRoomBloc(
                      chatService: chatService,
                      messageService: messageService,
                      chatId: newChat.id,
                    )..add(LoadMoreMessagesEvent()),
                  ),
                ],
                child: ChatRoomScreen(chatId: newChat.id),
              ),
            ));
            break;
          }
        }
      }
    }
  }

  _onSelect(BuildContext context, ChatEntity chat) {
    if (context.mounted) {
      // 이미 상위에서 주입된 서비스들을 사용
      final chatService = context.read<ChatService>();
      final messageService = context.read<MessageService>();

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            // 필요한 서비스들 다시 제공
            // RepositoryProvider.value(value: chatService),
            // RepositoryProvider.value(value: messageService),
            // 채팅방 블록 생성 및 제공
            BlocProvider(
              create: (context) => ChatRoomBloc(
                chatService: chatService,
                messageService: messageService,
                chatId: chat.id,
              )..add(LoadMoreMessagesEvent()),
            ),
          ],
          child: ChatRoomScreen(chatId: chat.id),
        ),
      ));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatListBloc, ChatListState>(
      listener: (context, state) {
        final error = state.error;
        if (error != null) {
          ScaffoldMessenger.of(context).clearSnackBars(); // 기존 스낵바 제거

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: '확인',
                textColor: Colors.white,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  // 에러 발생 시 새로고침
                  context.read<ChatListBloc>().add(RefreshChatsEvent());
                },
              ),
            ),
          );
        }

        // 상태별 추가 에러 처리
        if (state.chats case AsyncError(message: final message)) {
          print('Chat list load error: $message'); // 로깅 추가
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('채팅 목록을 불러오는데 실패했습니다: $message'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent, // 스크롤 제스처와 충돌 방지
          onTap: () {
            FocusScope.of(context).unfocus(); // 포커스 해제
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              ChatListSliverAppBar(
                onCreateChat: (friend, title) => _createChat(
                  context,
                  friend,
                  title,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SearchTextField(
                    placeholder: "대화내용 검색",
                    controller: _searchController,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height -
                          200, // AppBar와 SearchField 높이를 고려한 값
                      child: switch (state.chats) {
                        AsyncInitial() =>
                          const Center(child: Text("채팅방을 불러오는 중...")),
                        AsyncLoading() =>
                          const Center(child: CircularProgressIndicator()),
                        AsyncError(message: final message) =>
                          Center(child: Text(message)),
                        AsyncData(data: final chats) =>
                          Builder(builder: (context) {
                            final filteredChats = _getFilteredChats(chats);

                            if (filteredChats.isEmpty) {
                              return Center(
                                child: Text(_searchController.text.isEmpty
                                    ? "채팅방이 없습니다"
                                    : "검색 결과가 없습니다"),
                              );
                            }

                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredChats.length,
                              itemBuilder: (context, index) {
                                final chat = filteredChats[index];
                                return ChatListItem(
                                  chat: chat,
                                  onTap: (chat) => _onSelect(context, chat),
                                );
                              },
                            );
                          }),
                      },
                    ),
                  ),
                ),
              ),
              if (state.hasMore && state.chats is AsyncData)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
