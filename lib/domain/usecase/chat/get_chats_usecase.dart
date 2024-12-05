import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/chat_repository.dart';
import 'package:fluttalk/domain/entities/chat_entity.dart';
import 'package:fluttalk/domain/entities/pagination_list.dart';
import 'package:fpdart/fpdart.dart';

class GetChatsUseCase {
  final ChatRepository _chatRepository;

  GetChatsUseCase(this._chatRepository);

  Future<Either<AppException, PaginatedList<ChatEntity>>> execute({
    String? startAt,
  }) async {
    try {
      final response = await _chatRepository.getChats(startAt: startAt);

      if (response.code != null) {
        final code = response.code ?? 500;
        final message = response.message ?? '알 수 없는 오류가 발생했습니다';
        return Left(ApiException(code: code, message: message));
      }

      return Right(PaginatedList(
        items:
            response.results?.map((model) => ChatEntity.from(model)).toList() ??
                [],
        nextKey: response.nextKey,
      ));
    } catch (e) {
      return Left(AppErrorHandler.handle(e));
    }
  }
}
