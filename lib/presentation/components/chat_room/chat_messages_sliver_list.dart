import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/domain/entities/message_entity.dart';
import 'package:fluttalk/presentation/bloc/base/async_value.dart';
import 'package:fluttalk/presentation/blocs/chat_room/chat_room_bloc.dart';
import 'package:fluttalk/presentation/components/chat_room/chat_message_ballon.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessagesSliverList extends StatelessWidget {
  const ChatMessagesSliverList({super.key});

  @override
  Widget build(BuildContext context) {
    // ChatRoomBloc으로부터 상태를 가져온다.
    final chatState = context.watch<ChatRoomBloc>().state;

    // UserBloc으로부터 현재 사용자 정보 상태를 가져온다.
    final userState =
        context.watch<AuthRepository>().currentUser; // 가정: userState.uid 존재

    // 메시지 리스트 추출
    List<MessageEntity> messages = [];
    if (chatState.messages is AsyncData<List<MessageEntity>>) {
      messages = (chatState.messages as AsyncData<List<MessageEntity>>).data;
    }

    final currentUserId = userState?.uid ?? ''; // 사용자 식별자 (UserBloc 상태로부터)

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: messages.length,
        (context, index) {
          final message = messages[index];
          return ChatMessageBalloon(
            key: ValueKey(message.sentAt),
            message: message,
            isUsers: message.isUsers(currentUserId),
          );
        },
      ),
    );
  }
}
