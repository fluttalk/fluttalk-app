import 'package:fluttalk/core/error/error.dart';
import 'package:fluttalk/data/repositories/friend_repository.dart';
import 'package:fluttalk/domain/entities/friend_entity.dart';
import 'package:fpdart/fpdart.dart';

class GetFriendsUseCase {
  final FriendRepository _friendRepository;

  GetFriendsUseCase(this._friendRepository);

  Future<Either<AppException, List<FriendEntity>>> execute() async {
    try {
      final response = await _friendRepository.getFriends();

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

      final friends = response.results;
      if (friends == null) {
        return const Left(
          NoResultsException(),
        );
      }

      return Right(
        friends
            .map(
              (model) => FriendEntity.fromUserModel(model),
            )
            .toList(),
      );
    } catch (e) {
      return Left(
        AppErrorHandler.handle(e),
      );
    }
  }
}
