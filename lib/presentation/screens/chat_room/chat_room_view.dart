import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';
import 'package:fluttalk/presentation/blocs/chat_room/chat_room_bloc.dart';
import 'package:fluttalk/presentation/blocs/chat_room/chat_room_event.dart';
import 'package:fluttalk/presentation/blocs/chat_room/chat_room_state.dart';
import 'package:fluttalk/presentation/components/chat_room/chat_room_message_text_field.dart';
import 'package:fluttalk/presentation/components/chat_room/chat_room_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoomView extends StatefulWidget {
  final String chatId;
  const ChatRoomView({super.key, required this.chatId});

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels <= 0) {
      context.read<ChatRoomBloc>().add(LoadMoreMessagesEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthRepository>().currentUser;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<ChatRoomBloc, ChatRoomState>(
              builder: (context, state) {
                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    const ChatRoomSliverAppBar(),
                    switch (state.messages) {
                      AsyncInitial() => const SliverFillRemaining(
                          child: Center(child: Text("메시지를 불러오는 중...")),
                        ),
                      AsyncLoading() => const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      AsyncError(message: final message) => SliverFillRemaining(
                          child: Center(child: Text(message)),
                        ),
                      AsyncData(data: final messages) => messages.isEmpty
                          ? const SliverFillRemaining(
                              child: Center(child: Text("메시지가 없습니다")),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final message = messages[index];
                                  final isMyMessage =
                                      message.senderId == currentUser?.uid;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: isMyMessage
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isMyMessage
                                                ? Colors.blue
                                                : Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            message.content,
                                            style: TextStyle(
                                              color: isMyMessage
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                childCount: messages.length,
                              ),
                            ),
                    },
                    const SliverToBoxAdapter(
                      child: SizedBox(height: ChatRoomMessageTextField.height),
                    ),
                  ],
                );
              },
            ),
            const ChatRoomMessageTextField(),
          ],
        ),
      ),
    );
  }
}
