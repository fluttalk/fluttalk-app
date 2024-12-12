import 'package:fluttalk/domain/entities/message_entity.dart';
import 'package:fluttalk/presentation/common/position_retained_scroll_physics.dart';
import 'package:fluttalk/presentation/components/chat_room/chat_messages_sliver_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluttalk/presentation/components/chat_room/chat_room_sliver_app_bar.dart';
import 'package:fluttalk/presentation/blocs/chat_room/chat_room_bloc.dart';
import 'package:fluttalk/presentation/blocs/chat_room/chat_room_event.dart';
import 'package:fluttalk/presentation/blocs/chat_room/chat_room_state.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';

class ChatScrollView extends StatefulWidget {
  const ChatScrollView({super.key});

  @override
  State<ChatScrollView> createState() => _ChatScrollViewState();
}

class _ChatScrollViewState extends State<ChatScrollView> {
  final _scrollController = ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_registerScrollListener);
  }

  void _registerScrollListener() {
    final chatBloc = context.read<ChatRoomBloc>();
    final state = chatBloc.state;

    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels == 0 &&
        state.hasMore) {
      chatBloc.add(LoadMoreMessagesEvent());
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_registerScrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatRoomBloc, ChatRoomState>(
      listenWhen: (previous, current) {
        if (previous.messages is AsyncData && current.messages is AsyncData) {
          final prevMsgs =
              (previous.messages as AsyncData<List<MessageEntity>>).data;
          final currMsgs =
              (current.messages as AsyncData<List<MessageEntity>>).data;
          return currMsgs.length != prevMsgs.length;
        }
        return previous.messages != current.messages;
      },
      listener: (context, state) {
        if (state.messages is AsyncData) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        // List<MessageEntity> messageList = [];
        // if (state.messages is AsyncData<List<MessageEntity>>) {
        //   // AsyncData일 경우 data로 메시지 리스트에 접근 가능
        //   messageList = (state.messages as AsyncData<List<MessageEntity>>).data;
        // }

        return CustomScrollView(
          physics: const PositionRetainedScrollPhysics(),
          controller: _scrollController,
          slivers: const [
            ChatRoomSliverAppBar(),
            ChatMessagesSliverList(),
          ],
        );
      },
    );
  }
}
