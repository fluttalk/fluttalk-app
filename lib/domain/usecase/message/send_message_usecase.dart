import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/message_repository.dart';
import 'package:fluttalk/domain/entities/message_entity.dart';
import 'package:fpdart/fpdart.dart';

class SendMessageUseCase {
  final MessageRepository _messageRepository;

  SendMessageUseCase(this._messageRepository);

  Future<Either<AppException, MessageEntity>> execute({
    required String chatId,
    required String content,
  }) async {
    try {
      final response = await _messageRepository.sendMessage(
        chatId: chatId,
        content: content,
      );

      if (response.code != null) {
        final code = response.code ?? 500;
        final message = response.message ?? '알 수 없는 오류가 발생했습니다';
        return Left(ApiException(code: code, message: message));
      }

      final message = response.result;
      if (message == null) {
        return const Left(NoResultException());
      }

      return Right(MessageEntity.from(message));
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }
}
