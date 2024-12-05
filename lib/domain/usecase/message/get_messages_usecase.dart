import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/message_repository.dart';
import 'package:fluttalk/domain/entities/message_entity.dart';
import 'package:fluttalk/domain/entities/pagination_list.dart';
import 'package:fpdart/fpdart.dart';

class GetMessagesUseCase {
  final MessageRepository _messageRepository;

  GetMessagesUseCase(this._messageRepository);

  Future<Either<AppException, PaginatedList<MessageEntity>>> execute({
    required String chatId,
    String? startAt,
  }) async {
    try {
      final response = await _messageRepository.getMessages(
        chatId: chatId,
        startAt: startAt,
      );

      if (response.code != null) {
        final code = response.code ?? 500;
        final message = response.message ?? '알 수 없는 오류가 발생했습니다';
        return Left(ApiException(code: code, message: message));
      }

      return Right(PaginatedList(
        items: response.results
                ?.map((model) => MessageEntity.from(model))
                .toList() ??
            [],
        nextKey: response.nextKey,
      ));
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }
}
