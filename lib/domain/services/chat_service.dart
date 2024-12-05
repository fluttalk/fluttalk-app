// domain/services/chat_service.dart
import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/domain/entities/chat_entity.dart';
import 'package:fluttalk/domain/entities/pagination_list.dart';
import 'package:fluttalk/domain/usecase/chat/index.dart';
import 'package:fluttalk/domain/usecase/chat/wath_chat_useacase.dart';
import 'package:fpdart/fpdart.dart';

class ChatService {
  final GetChatsUseCase _getChatsUseCase;
  final CreateChatUseCase _createChatUseCase;
  final WatchChatUseCase _watchChatUseCase;

  ChatService(
    this._getChatsUseCase,
    this._createChatUseCase,
    this._watchChatUseCase,
  );

  // 채팅방 목록을 가져옵니다. 페이지네이션을 지원합니다.
  Future<Either<AppException, PaginatedList<ChatEntity>>> getChats({
    String? startAt,
  }) {
    return _getChatsUseCase.execute(startAt: startAt);
  }

  // 새로운 채팅방을 생성합니다. 상대방의 이메일과 채팅방 제목이 필요합니다.
  Future<Either<AppException, ChatEntity>> createChat({
    required String email,
    required String title,
  }) {
    return _createChatUseCase.execute(
      email: email,
      title: title,
    );
  }

  Stream<Either<AppException, ChatEntity>> watchChat(String chatId) {
    return _watchChatUseCase.execute(chatId);
  }
}
