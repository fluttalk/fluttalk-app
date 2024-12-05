import 'package:fluttalk/data/repositories/chat_repository.dart';
import 'package:fluttalk/data/repositories/message_repository.dart';
import 'package:fluttalk/domain/services/chat_service.dart';
import 'package:fluttalk/domain/services/message_service.dart';
import 'package:fluttalk/domain/usecase/chat/index.dart';
import 'package:fluttalk/domain/usecase/message/index.dart';
import 'package:fluttalk/presentation/blocs/chat_list/chat_list_bloc.dart';
// import 'package:fluttalk/presentation/components/chat_list/chat_list_item.dart';
// import 'package:fluttalk/presentation/components/chat_list/chat_list_sliver_app_bar.dart';
// import 'package:fluttalk/presentation/components/common/search_text_field.dart';
// import 'package:fluttalk/presentation/screens/chat_room/chat_room_screen.dart';
import 'package:fluttalk/presentation/screens/home/chat_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatRepo = context.read<ChatRepository>();
    final messageRepo = context.read<MessageRepository>();

    // Chat Service 생성
    final chatService = ChatService(
      GetChatsUseCase(chatRepo),
      CreateChatUseCase(chatRepo),
      WatchChatUseCase(chatRepo),
    );

    // Message Service 생성
    final messageService = MessageService(
      GetMessagesUseCase(messageRepo),
      GetNewMessagesUseCase(messageRepo),
      SendMessageUseCase(messageRepo),
    );
    return MultiBlocProvider(
      providers: [
        RepositoryProvider.value(value: chatService),
        RepositoryProvider.value(value: messageService),
        BlocProvider(
          create: (context) => ChatListBloc(
            chatService: chatService,
          ),
        )
      ],
      child: const ChatListView(),
    );
  }
}

// class ChatListScreen extends StatelessWidget {
//   const ChatListScreen({super.key});

//   _onTap(BuildContext context, int index) {
//     Navigator.of(context).push(MaterialPageRoute(
//       builder: (context) {
//         return const ChatRoomScreen();
//       },
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: [
//         const ChatListSliverAppBar(),
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (_, index) => switch (index) {
//               0 => const SearchTextField(placeholder: "Search"),
//               _ => ChatListItem(
//                   onTap: () => _onTap(context, index),
//                 ),
//             },
//             childCount: 20,
//           ),
//         ),
//       ],
//     );
//   }
// }
