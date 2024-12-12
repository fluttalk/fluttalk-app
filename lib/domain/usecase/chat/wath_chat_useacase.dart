import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/chat_repository.dart';
import 'package:fluttalk/domain/entities/chat_entity.dart';
import 'package:fpdart/fpdart.dart';

class WatchChatUseCase {
  final ChatRepository _chatRepository;

  WatchChatUseCase(this._chatRepository);

  Stream<Either<AppException, ChatEntity>> execute(String chatId) {
    try {
      return _chatRepository.watchChat(chatId).map((chat) {
        if (chat == null) {
          return const Left(DataFormatException('채팅방 정보가 없습니다'));
        }
        // print(chat);
        return Right(ChatEntity.from(chat));
      });
    } catch (e) {
      return Stream.value(Left(AppErrorHandler.handle(e)));
    }
  }
}
