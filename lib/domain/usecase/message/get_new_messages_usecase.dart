import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/message_repository.dart';
import 'package:fluttalk/domain/entities/message_entity.dart';
import 'package:fpdart/fpdart.dart';

class GetNewMessagesUseCase {
  final MessageRepository _messageRepository;

  GetNewMessagesUseCase(this._messageRepository);

  Future<Either<AppException, List<MessageEntity>>> execute({
    required String chatId,
    required int lastNewestSentAt,
  }) async {
    try {
      final response = await _messageRepository.getNewMessages(
        chatId: chatId,
        lastNewestSentAt: lastNewestSentAt,
      );

      if (response.code != null) {
        final code = response.code ?? 500;
        final message = response.message ?? '알 수 없는 오류가 발생했습니다';
        return Left(ApiException(code: code, message: message));
      }

      return Right(response.results
              ?.map((model) => MessageEntity.from(model))
              .toList() ??
          []);
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }
}
