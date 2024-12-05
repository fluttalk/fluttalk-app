import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/chat_repository.dart';
import 'package:fluttalk/domain/entities/chat_entity.dart';
import 'package:fpdart/fpdart.dart';

class CreateChatUseCase {
  final ChatRepository _chatRepository;

  CreateChatUseCase(this._chatRepository);

  Future<Either<AppException, ChatEntity>> execute({
    required String email,
    required String title,
  }) async {
    try {
      final response = await _chatRepository.createChat(
        email: email,
        title: title,
      );

      if (response.code != null) {
        final code = response.code ?? 500;
        final message = response.message ?? '알 수 없는 오류가 발생했습니다';
        return Left(
          ApiException(
            code: code,
            message: message,
          ),
        );
      }

      final chat = response.result;
      if (chat == null) {
        return const Left(
          NoResultException(),
        );
      }

      return Right(ChatEntity.from(chat));
    } catch (e) {
      return Left(
        AppErrorHandler.handle(e),
      );
    }
  }
}
