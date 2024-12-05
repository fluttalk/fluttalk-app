import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/domain/entities/message_entity.dart';
import 'package:fluttalk/domain/entities/pagination_list.dart';
import 'package:fluttalk/domain/usecase/message/index.dart';
import 'package:fpdart/fpdart.dart';

class MessageService {
  final GetMessagesUseCase _getMessagesUseCase;
  final GetNewMessagesUseCase _getNewMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;

  MessageService(
    this._getMessagesUseCase,
    this._getNewMessagesUseCase,
    this._sendMessageUseCase,
  );

  // 특정 채팅방의 메시지 목록을 가져옵니다. 페이지네이션을 지원합니다.
  Future<Either<AppException, PaginatedList<MessageEntity>>> getMessages({
    required String chatId,
    String? startAt,
  }) {
    return _getMessagesUseCase.execute(
      chatId: chatId,
      startAt: startAt,
    );
  }

  // 특정 채팅방의 새로운 메시지들을 가져옵니다.
  // lastNewestSentAt 이후의 메시지들만 조회합니다.
  Future<Either<AppException, List<MessageEntity>>> getNewMessages({
    required String chatId,
    required int lastNewestSentAt,
  }) {
    return _getNewMessagesUseCase.execute(
      chatId: chatId,
      lastNewestSentAt: lastNewestSentAt,
    );
  }

  // 특정 채팅방에 메시지를 전송합니다.
  Future<Either<AppException, MessageEntity>> sendMessage({
    required String chatId,
    required String content,
  }) {
    return _sendMessageUseCase.execute(
      chatId: chatId,
      content: content,
    );
  }
}
