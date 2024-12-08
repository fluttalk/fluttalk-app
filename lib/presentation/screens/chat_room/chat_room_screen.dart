import 'package:fluttalk/data/repositories/auth_repository.dart';
import 'package:fluttalk/data/repositories/chat_repository.dart';
import 'package:fluttalk/data/repositories/message_repository.dart';
import 'package:fluttalk/data/repositories/user_repository.dart';
import 'package:fluttalk/domain/services/auth_service.dart';
import 'package:fluttalk/domain/services/chat_service.dart';
import 'package:fluttalk/domain/services/message_service.dart';
import 'package:fluttalk/domain/services/user_service.dart';
import 'package:fluttalk/domain/usecase/auth/index.dart';
import 'package:fluttalk/domain/usecase/chat/index.dart';
import 'package:fluttalk/domain/usecase/message/index.dart';
import 'package:fluttalk/domain/usecase/user/index.dart';
import 'package:fluttalk/presentation/blocs/chat_room/chat_room_bloc.dart';
import 'package:fluttalk/presentation/blocs/me_cubit.dart';
import 'package:fluttalk/presentation/screens/chat_room/chat_room_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoomScreen extends StatelessWidget {
  final String chatId;

  const ChatRoomScreen({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    final getChatsUseCase = GetChatsUseCase(context.read<ChatRepository>());
    final createChatUseCase = CreateChatUseCase(context.read<ChatRepository>());
    final watchChatUseCase = WatchChatUseCase(context.read<ChatRepository>());
    final chatService = ChatService(
      getChatsUseCase,
      createChatUseCase,
      watchChatUseCase,
    );
    final getMessageUseCase =
        GetMessagesUseCase(context.read<MessageRepository>());
    final getNewMessageUSeCase =
        GetNewMessagesUseCase(context.read<MessageRepository>());
    final sendMessageUsecase =
        SendMessageUseCase(context.read<MessageRepository>());
    final messageService = MessageService(
      getMessageUseCase,
      getNewMessageUSeCase,
      sendMessageUsecase,
    );

    return MultiBlocProvider(
      providers: [
        RepositoryProvider.value(value: chatService),
        RepositoryProvider.value(value: messageService),
        BlocProvider(
          create: (context) => ChatRoomBloc(
            messageService: messageService,
            chatService: chatService,
            chatId: chatId,
          ),
        ),
      ],
      child: ChatRoomView(
        chatId: chatId,
      ),
    );
  }
}


// class ChatRoomScreen extends StatelessWidget {
//   final String chatId;

//   const ChatRoomScreen({super.key, required this.chatId});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             CustomScrollView(
//               slivers: [
//                 ChatRoomSliverAppBar(),
//                 SliverToBoxAdapter(
//                   child: Placeholder(),
//                 ),
//                 SliverToBoxAdapter(
//                   child: Placeholder(),
//                 ),
//                 SliverToBoxAdapter(
//                   child: Placeholder(),
//                 ),
//                 SliverToBoxAdapter(
//                   child: SizedBox(height: ChatRoomMessageTextField.height),
//                 ),
//               ],
//             ),
//             ChatRoomMessageTextField(),
//           ],
//         ),
//       ),
//     );
//   }
// }
